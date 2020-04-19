#!/usr/bin/env kscript

//COMPILER_OPTS -jvm-target 1.8

import Changelog.Type.*
import java.io.BufferedReader
import java.util.stream.Collectors
import java.util.stream.Stream

//region Argument handling
var argIndex = 0
fun argument(index: Int): String? = if (index < args.size) args[index] else null
//endregion

//region Formatting
sealed class Printer {
	abstract fun title(message: String)
	abstract fun text(message: String)
	abstract fun item(message: String)
	abstract fun url(message: String, url: String)

	object Markdown : Printer() {
		override fun title(message: String) = println("# $message")
		override fun text(message: String) = println(message)
		override fun item(message: String) = println("- $message")
		override fun url(message: String, url: String) = println("[$message]($url)")
	}

	object TelegramHtml : Printer() {
		//language=HTML
		override fun title(message: String) = println("<strong>$message</strong>")
		override fun text(message: String) = println(message)
		override fun item(message: String) = println("· $message")

		//language=HTML
		override fun url(message: String, url: String) = println("<a href='$url'>$message</a>")

		val String.escaped: String
			get() = this.replace("&", "&amp").replace("<", "&lt").replace(">", "&gt").replace("\"", "&quot").replace("\'", "&#39")
	}

	companion object : Printer() {
		lateinit var selected: Printer

		override fun title(message: String) = selected.title(message)
		override fun text(message: String) = selected.text(message)
		override fun item(message: String) = selected.item(message)
		override fun url(message: String, url: String) = selected.url(message, url)
	}
}

if (argument(argIndex) == "--format") {
	Printer.selected = when (argument(argIndex + 1)) {
		"markdown" -> Printer.Markdown
		"telegram-html" -> Printer.TelegramHtml
		else -> throw IllegalArgumentException("Invalid formatter: ${args[argIndex + 1]}")
	}
	argIndex += 2
} else {
	Printer.selected = Printer.Markdown
}
//endregion

//region Title
if (argument(argIndex) != "--no-title") {
	val projectName = System.getenv("CI_PROJECT_TITLE")
	Printer.title("Changelog${if (projectName != null) " of $projectName" else ""}")
} else {
	argIndex++
}
//endregion

//region Commit range
val commitRange = argument(argIndex) ?: ""
Printer.text("Git options: '$commitRange'")
//endregion

//region Sorting
enum class Type(val prettyName: String) {
	BUILD("Build"), CI("CI/CD"), DOC("Documentation"), FEAT("New features"), FIX("Fixes"), PERF("Performance improvements"), REFACTOR("Refactoring"), STYLE("Style modifications"), TEST("Tests"), BREAKING("Breaking changes"), MERGE("Merges"), UNKNOWN("Unsorted"),
}

fun Commit.findType(): Pair<Type, Commit> = with(subject) {
	when {
		startsWith("feat(") -> FEAT to asAngular()
		startsWith("feat") -> FEAT to asESLint()

		startsWith("build(") -> BUILD to asAngular()
		startsWith("build") -> BUILD to asESLint()

		startsWith("ci(") -> CI to asAngular()
		startsWith("ci") -> CI to asESLint()

		startsWith("fix(") -> FIX to asAngular()
		startsWith("fixes(") -> FIX to asAngular()
		startsWith("fix") -> FIX to asESLint()

		startsWith("doc(") -> DOC to asAngular()
		startsWith("docs(") -> DOC to asAngular()
		startsWith("doc") -> DOC to asESLint()

		startsWith("perf(") -> PERF to asAngular()
		startsWith("perfs(") -> PERF to asAngular()
		startsWith("perf") -> PERF to asESLint()

		startsWith("refactor(") -> REFACTOR to asAngular()
		startsWith("refactor") -> REFACTOR to asESLint()

		startsWith("style(") -> STYLE to asAngular()
		startsWith("style") -> STYLE to asESLint()

		startsWith("test(") -> TEST to asAngular()
		startsWith("tests(") -> TEST to asAngular()
		startsWith("test") -> TEST to asESLint()

		startsWith("breaking(") -> BREAKING to asAngular()
		startsWith("breaking") -> BREAKING to asESLint()

		startsWith("Merge branch ") -> MERGE to this@findType

		else -> UNKNOWN to this@findType
	}
}

fun Stream<Commit>.findType() = map { it.findType() }
//endregion

//region Commit data
data class Commit(val id: String, val author: String, val committer: String, val subject: String, val scope: String? = null)

//LANGUAGE=RegEx
val angularRegex = "(.*): ".toRegex()
fun Commit.asAngular(): Commit = copy(subject = angularRegex.replaceFirst(subject, ""), scope = subject.substring(subject.indexOf('(') + 1, subject.indexOf(')')))

fun Commit.asESLint(): Commit = copy(subject = subject.substring(subject.indexOf(':') + 2))

fun asCommit(commit: String): Commit {
	val (id, author, committer, subject) = commit.split("::::")

	return Commit(id, author, committer, subject)
}

fun Stream<String>.asCommits() = map(::asCommit)
//endregion

//region Execute
fun shell(command: String): BufferedReader {
	val process: Process = ProcessBuilder().command("bash", "-c", command).start()
	return process.inputStream.bufferedReader()
}

fun BufferedReader.collectAsString(): String {
	var line = ""
	forEachLine {
		line += it + "\n"
	}
	return line.trim('\n')
}

fun Stream<String>.getCommitInformation() = map { shell("git show --quiet --pretty=\"%h::::%an::::%cn::::%s\" $it").collectAsString() }

fun Stream<Pair<Type, Commit>>.display() {
	val data = collect(Collectors.toList())
	val sorted = data.groupBy { it.first }.map { entry -> entry.key to entry.value.map { it.second } }

	for ((type, commits) in sorted) {
		println()
		Printer.text(type.prettyName + ":")

		for (commit in commits) {
			val message = StringBuilder().append(commit.subject).append(" (").append(commit.id)

			if (commit.scope != null && commit.scope != "") {
				message.append(", in ‘").append(commit.scope).append("’")
			}

			message.append(")")
			Printer.item(message.toString())
		}
	}
}

fun Stream<String>.startPipeline() = this.parallel().getCommitInformation().asCommits().findType().display()

shell("git log --pretty=format:'%h' $commitRange").lines().startPipeline()

//endregion
