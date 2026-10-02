# Start here: Contributor Month, October 2026

Welcome! This page takes you from "I'd like to help" to your first merged contribution to .NET **nanoFramework**, the platform that lets you write C# for microcontrollers.

> [!NOTE]
> Hacktoberfest changed in 2026: pull requests no longer count toward its rewards. We are running October as our own Contributor Month anyway. There is no swag for PRs; there are well-prepared issues, quick reviews and maintainers around to help.

## What you can expect from us

- A curated list of starter issues, each with pointers to the repository and files involved.
- A first reply on your pull request within 48 hours.
- Maintainers available in the Hacktoberfest channel on our [Discord server](https://discord.gg/gCyBu8T).
- Your name in the thank-you post at the end of the month.

## Pick your track

| Track | Good fit if you... | Where to look |
| --- | --- | --- |
| Code | know C# or C/C++ and want to fix a bug or add a feature in the class libraries, firmware or tools | [good first issue](https://github.com/nanoframework/Home/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22), then [up-for-grabs](https://github.com/nanoframework/Home/issues?q=is%3Aissue+is%3Aopen+label%3Aup-for-grabs) |
| Docs and content | like explaining things: device guides, samples, tutorials, blog posts, fixing unclear pages | [documentation issues](https://github.com/nanoframework/Home/issues?q=is%3Aissue+is%3Aopen+label%3A%22Type%3A+documentation%22) and the [documentation repository](https://github.com/nanoframework/nanoframework.github.io) |
| Hardware testing | own an ESP32, STM32, Raspberry Pi Pico or M5Stack board, or sensors and modules, and can check that code, samples and guides work on real hardware | `hardware-test` issues in [Home](https://github.com/nanoframework/Home/issues?q=is%3Aissue+is%3Aopen+label%3Ahardware-test) and in the [IoT device bindings](https://github.com/nanoframework/nanoFramework.IoT.Device/issues?q=is%3Aissue+is%3Aopen+label%3Ahardware-test) repository, which has the most to test |

All issues for the whole project live in a single place: the [Home repository](https://github.com/nanoframework/Home/issues). The code lives in other repositories, and each starter issue tells you which one.

## Get set up in 15 minutes

1. Install the tools by following the [getting started guide for managed code](https://docs.nanoframework.net/content/getting-started-guides/getting-started-managed.html) (Visual Studio) or the [VS Code guide](https://docs.nanoframework.net/content/getting-started-guides/getting-started-vs-code.html).
1. No board? Use the [virtual device](https://docs.nanoframework.net/content/getting-started-guides/virtual-device.html). Have a board? Flash it as described in the getting started guide.
1. Run a "blinky" or "Hello World" from the [Samples repository](https://github.com/nanoframework/Samples) to confirm everything works.
1. Join the [Discord server](https://discord.gg/gCyBu8T) and say hello in the Hacktoberfest channel.

Working on the firmware itself (C/C++) needs a bigger setup. See the [build instructions](https://docs.nanoframework.net/content/building/build-instructions.html), and consider the [dev container](https://docs.nanoframework.net/content/building/using-dev-container.html) to save time.

## Make your first contribution

1. **Choose an issue** from the lists above. Labels help you judge the size: `trivial` is quick and needs no deep knowledge of the project, `non trivial` is better kept for a second contribution.
1. **Comment on the issue** to say you want to work on it. It will be assigned to you, so nobody duplicates your work. Please take one issue at a time.
1. **Fork and branch** the repository the issue points to. The [contribution workflow](https://docs.nanoframework.net/content/contributing/contributing-workflow.html) explains the steps and the commit message format.
1. **Make the change and test it** on a device or on the virtual device. Say in the pull request how you tested.
1. **Open the pull request** and link the issue. You will be asked to sign the [Contributor License Agreement](https://docs.nanoframework.net/content/contributing/cla.html) the first time.
1. **Respond to the review.** Requests for changes are normal and are not a sign that your work is unwelcome.

Fixing a typo or a broken link? You don't need an issue for that: open the pull request directly.

## Ground rules

- One focused change per pull request.
- AI-assisted contributions are welcome if you understand the change and have tested it. Untested, generated pull requests will be closed.
- Please don't send pull requests that only change code style. Follow the style of the file you are editing; see the [C#](https://docs.nanoframework.net/content/contributing/cs-coding-style.html) and [C/C++](https://docs.nanoframework.net/content/contributing/cxx-coding-style.html) guidelines.
- Writing documentation? Read the [Markdown rules](https://docs.nanoframework.net/content/contributing/markdown-creation.html) first.
- Be kind. Everyone here is a volunteer.

## Stuck?

Ask in the Hacktoberfest channel on [Discord](https://discord.gg/gCyBu8T), or comment on the issue. No question is too small, and asking early saves everyone time.

## Other ways to help

- Star the repositories and tell others about the project.
- Publish a project, tutorial or video that uses .NET **nanoFramework**.
- Support the project financially through [Open Collective](https://opencollective.com/nanoframework) or [GitHub Sponsors](https://github.com/sponsors/nanoframework). See [financial sponsors](https://docs.nanoframework.net/content/contributing/financial-sponsors.html) for what the funding pays for.
- Does your company ship a product built on .NET **nanoFramework**? Tell us on Discord. We would love to feature it.
