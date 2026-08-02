//! The README's opening example, so it cannot quietly stop being true.
use quill::{parse, Style};

fn main() {
    let parsed = parse("A **bold** claim.");

    assert_eq!(parsed.spans[0].style, Style::Bold);
    assert_eq!((parsed.spans[0].start, parsed.spans[0].end), (4, 8));

    assert_eq!(parsed.markers.len(), 2);
    assert_eq!(quill::strip("A **bold** claim."), "A bold claim.");

    println!("the README is honest");
}
