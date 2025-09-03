#import "@preview/touying:0.6.1": *
#import "@preview/cetz:0.4.1"
#import "@preview/fletcher:0.5.8" as fletcher: edge, node
#import "@preview/numbly:0.1.0": numbly
#import "@preview/theorion:0.4.0": *
#import cosmos.clouds: *
#show: show-theorion
#import themes.university: *
#import themes.stargazer: *
#import "./utils/color.typ": colorize

// Lang and font configuration

#let ppt-theme(
  aspect-ratio: "16-9",
  lang: "zh",
  font: (
    (
      name: "Libertinus Serif",
      covers: "latin-in-cjk",
    ),
    "Source Han Sans SC",
    "Source Han Sans",
  ),
  ..args,
  body,
) = {
  set text(lang: lang, font: font)
  show: if lang == "zh" {
    import "@preview/cuti:0.3.0": show-cn-fakebold
    show-cn-fakebold
  } else {
    it => it
  }

  show heading.where(level: 1): set heading(numbering: "1.")
  show heading.where(level: 2): set heading(numbering: "1.")

  show: stargazer-theme.with(
    aspect-ratio: aspect-ratio,
    config-info(
      logo: [#image(colorize(read("nenu-logo.svg"), blue), format: "svg")],
    ),
    ..args,
    config-colors(
      primary: rgb("#3f4ed3"),
    ),
    config-page(),
    config-methods(),
    config-store(
      navigation: self => components.simple-navigation(
        self: self,
        primary: white,
        secondary: gray,
        background: self.colors.neutral-darkest,
        logo: utils.call-or-display(self, self.store.header-right),
      ),
      header: self => if self.store.title != none {
        block(
          width: 100%,
          height: 1.5em,
          fill: gradient.linear(self.colors.primary, self.colors.neutral-darkest),
          place(
            left + horizon,
            text(fill: self.colors.neutral-lightest, weight: "bold", size: 1.3em, utils.call-or-display(
              self,
              self.store.title,
            )),
            dx: 1.5em,
          ),
        )
      },
      footer: self => {
        let cell(fill: none, it) = rect(
          width: 100%,
          height: 100%,
          inset: 1mm,
          outset: 0mm,
          fill: fill,
          stroke: none,
          std.align(horizon, text(fill: self.colors.neutral-lightest, it)),
        )
        grid(
          columns: self.store.footer-columns,
          rows: (1.5em, auto),
          cell(fill: self.colors.neutral-darkest, utils.call-or-display(self, self.store.footer-a)),
          cell(fill: self.colors.neutral-darkest, utils.call-or-display(self, self.store.footer-b)),
          cell(fill: self.colors.primary, utils.call-or-display(self, self.store.footer-c)),
          cell(fill: self.colors.primary, utils.call-or-display(self, self.store.footer-d)),
        )
      },
    ),
    // Pdfpc configuration
    // typst query --root . ./examples/main.typ --field value --one "<pdfpc-file>" > ./examples/main.pdfpc
    config-common(preamble: pdfpc.config(
      duration-minutes: 30,
      start-time: datetime(hour: 14, minute: 10, second: 0),
      end-time: datetime(hour: 14, minute: 40, second: 0),
      last-minutes: 5,
      note-font-size: 12,
      disable-markdown: false,
      default-transition: (
        type: "push",
        duration-seconds: 2,
        angle: ltr,
        alignment: "vertical",
        direction: "inward",
      ),
    )),
  )
  body
}

#let outline-slide = outline-slide.with(
  title: [目录],
  depth: 2,
  text-size: (1.3em, 1em),
  text-weight: ("bold", "regular"),
  text-fill: (rgb("#2E86AB"), rgb("#A23B72")),
  indent: (0em, 2em),
  vspace: (1em, 0.3em),
)
