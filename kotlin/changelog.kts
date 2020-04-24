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
var commitRange: String
if (argument(argIndex) == "--incoming") {
	commitRange = "incoming"
} else {
	commitRange = argument(argIndex) ?: ""
	Printer.text("Git options: '$commitRange'")
}
//endregion

//region Sorting
enum class Type(val prettyName: String) {
	BUILD("Build"), CI("CI/CD"), DOC("Documentation"), FEAT("New features"), FIX("Fixes"), PERF("Performance " + "improvements"), REFACTOR("Internal modifications"), STYLE("Style modifications"), TEST("Tests"), BREAKING("Breaking" + " changes"), MERGE("Merges"), UNKNOWN("Unsorted"), UPGRADE("Dependencies")
}

fun Commit.findType(): Pair<Type, Commit> = with(subject) {
	when {
		startsWith("feat") -> FEAT to withScope()
		startsWith("New") -> FEAT to withScope()

		startsWith("build") -> BUILD to withScope()
		startsWith("Build") -> BUILD to withScope()

		startsWith("upgrade") -> UPGRADE to withScope()
		startsWith("Upgrade") -> UPGRADE to withScope()

		startsWith("ci") -> CI to withScope()

		startsWith("fix") -> FIX to withScope()
		startsWith("fixes") -> FIX to withScope()
		startsWith("Fix") -> FIX to withScope()

		startsWith("doc") -> DOC to withScope()
		startsWith("docs") -> DOC to withScope()
		startsWith("Docs") -> DOC to withScope()

		startsWith("perf") -> PERF to withScope()
		startsWith("perfs") -> PERF to withScope()

		startsWith("refactor") -> REFACTOR to withScope()
		startsWith("Update") -> REFACTOR to withScope()

		startsWith("style") -> STYLE to withScope()

		startsWith("test") -> TEST to withScope()
		startsWith("tests") -> TEST to withScope()

		startsWith("breaking") -> BREAKING to withScope()
		startsWith("Breaking") -> BREAKING to withScope()

		startsWith("Merge branch ") -> MERGE to this@findType
		startsWith("merge") -> MERGE to withScope()

		else -> UNKNOWN to this@findType
	}
}

fun Stream<Commit>.findType() = map { it.findType() }
//endregion

//region Commit data
data class Commit(val id: String, val author: String, val committer: String, val subject: String, val scope: String? = null)

fun Commit.withScope(): Commit {
	val semicolon = subject.indexOf(':')

	val title = subject.substring(semicolon + 2)

	val openParenthesis = subject.indexOf('(')
	val closeParenthesis = subject.indexOf(')', openParenthesis + 1)

	return if (openParenthesis != -1 && closeParenthesis != -1 && closeParenthesis - openParenthesis != 1 && closeParenthesis < semicolon) {
		val scope = subject.substring(openParenthesis + 1, closeParenthesis)

		copy(subject = title, scope = scope)
	} else {
		copy(subject = title)
	}
}

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

fun Stream<Pair<Type, Commit>>.display(withHeader: Boolean) {
	val data = collect(Collectors.toList())
	val sorted = data.groupBy { it.first }.map { entry -> entry.key to entry.value.map { it.second } }

	if (withHeader) {
		println()
		shell("git show -s --format=\"%s%n%n%b%n%nMerger: %cn\" | sed 's|See merge " + "request \\(.*\\)!\\(.*\\)\$|More information: https://gitlab.com/\\1/-/merge_requests/\\2|'").lines().forEach(::println)

		println()
		Printer.title("Included modifications")
	}

	println()
	val authors = data.map { it.second.author }.toHashSet()
	val committers = data.map { it.second.committer }.toHashSet()

	if (authors.size == 1) {
		val author = authors.find { true }
		Printer.text("Author: $author")
	} else {
		Printer.text("Authors: ${authors.joinToString(", ")}")
	}

	if (committers.size == 1) {
		val committer = committers.find { true }
		Printer.text("Committer: $committer")
	} else {
		Printer.text("Committers: ${committers.joinToString(", ")}")
	}

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

fun Stream<String>.startPipeline(withHeader: Boolean) = this.parallel().getCommitInformation().asCommits().findType().display(withHeader)

if (commitRange == "incoming") {
	shell("git blog --exclude-first | grep \"current\" | sed -e 's/current://;s/^\\(.\\{7\\}\\).*/\\1/'").lines().startPipeline(true)
} else {
	shell("git log --pretty=format:'%h' $commitRange").lines().startPipeline(false)
}

//endregion