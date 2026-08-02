# quill

A Markdown scanner that reports **which characters are syntax**.

```rust
use quill::{parse, Style};

let parsed = parse("A **bold** claim.");

// What is styled…
assert_eq!(parsed.spans[0].style, Style::Bold);
assert_eq!((parsed.spans[0].start, parsed.spans[0].end), (4, 8));

// …and which characters you would hide to make it read as prose.
assert_eq!(parsed.markers.len(), 2);
assert_eq!(quill::strip("A **bold** claim."), "A bold claim.");
```

## Why not `pulldown-cmark`

A general Markdown library tells you a run of text is bold. It does not tell you
that characters 2–3 and 8–9 are the asterisks.

That distinction is the whole design. These apps show a note as source and style
it in place — one `GtkTextView`, never two widgets swapped — by tagging the
syntax characters with a tag carrying `invisible`. The note reads as prose, the
asterisks stay in the file, and the caret lands where you clicked. You cannot
build that from "this range is bold".

## No renderer

Nothing here draws, and the crate has **no dependencies at all**. `&str` in,
spans and markers out. That is deliberate: the apps using it reveal syntax on
different rules, and a shared renderer would have to fight all three.

| | reveals markers |
|---|---|
| [Stickies](https://github.com/mhagrelius/stickies) | all of them, when a note takes focus |
| [Brain](https://github.com/mhagrelius/brain) | only the construct under the caret, re-scanning one line per keystroke |
| [Familiar](https://github.com/mhagrelius/familiar) | never — and lifts tables out into real `GtkGrid`s |

## Offsets

Character offsets, everywhere, because that is what `GtkTextBuffer::iter_at_offset`
takes. Byte offsets would silently corrupt any note containing an accent or an
emoji.

## Scope

A subset of CommonMark plus notebook syntax: headings, emphasis, strikethrough,
inline code, fenced blocks, quotes, lists, links, wikilinks, embeds, tags, task
checkboxes, rules, frontmatter and pipe tables.

Not in it: reference links, nested emphasis, setext headings, HTML. Anything
unrecognised is left as plain text rather than half-styled — half-typed
formatting is the normal state while writing, and it must never swallow the rest
of the note.

Beyond scanning, the crate carries the few line edits that need the same
understanding of the syntax: `list_enter` (what pressing Return in a list should
insert), `renumber` (an ordered list whose numbers fell out of sequence) and
`extract` (the wikilinks, embeds and tags in a note, for an index).

## Tests

```sh
./test.sh
```

## Licence

GPL-3.0-or-later.
