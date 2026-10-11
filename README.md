# Codex CLI Ghost Prompt

Unofficial patch for the Codex CLI terminal composer. After a completed assistant answer includes a `Next prompt` / `下一步 prompt` heading followed by a fenced prompt, the composer shows a dim preview. Press `Tab` to insert the complete prompt.

This does not make the Codex desktop app or hosted Codex service behave differently. It only patches and builds the local Codex CLI.

## Build

Requirements: macOS or Linux, Git, Rust/Cargo, and the build dependencies listed by the upstream Codex CLI.

```sh
./build.sh
./codex-ghost
```

The script checks out the pinned upstream tag `rust-v0.162.1` into a temporary build directory, applies the patch in `patches/`, and builds the CLI. The resulting binary stays in that build directory; this repository does not include build artifacts or a copy of the full upstream source.

Set `CODEX_GHOST_BUILD_DIR` to choose a persistent build directory. Pass normal CLI arguments through the launcher, for example:

```sh
./codex-ghost --resume
```

## How it works

- Reads only the final assistant answer from a completed live turn.
- Looks for a `Next prompt` or `下一步 prompt` heading and the first following fenced code block.
- Shows the first non-empty line in the empty composer; `Tab` inserts the full prompt.
- Does not make an extra model request. Existing popup completion keeps its normal behavior.

## Upstream and license

This is an unofficial community patch based on [OpenAI Codex](https://github.com/openai/codex), pinned to `rust-v0.162.1`. It is not affiliated with or endorsed by OpenAI. See `UPSTREAM.md`, `LICENSE`, and `NOTICE` for provenance and license information. The Codex upstream contribution guide for this pinned version says it does not accept external code pull requests; use the upstream issue tracker for feature proposals.

## 中文说明

这是 Codex CLI 终端输入框的非官方补丁：助手回复中包含 `## 下一步 prompt`（或 `Next prompt`）标题及围栏代码块时，输入框会显示淡色预览；按 `Tab` 插入完整 prompt。它只修改本地 CLI，不会改变 Codex 桌面版或云端服务。
