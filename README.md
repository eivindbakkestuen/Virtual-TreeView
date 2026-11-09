# Virtual-TreeView

> **This is the `branch-footers` branch of [eivindbakkestuen/Virtual-TreeView](https://github.com/eivindbakkestuen/Virtual-TreeView), a fork of [JAM-Software/Virtual-TreeView](https://github.com/JAM-Software/Virtual-TreeView).**
> It adds a column **footer band** to the tree and fixes the header's `ParentFont` handling; see [What this branch adds](#what-this-branch-adds).
> Everything else is upstream Virtual Treeview: upstream `master` is merged into this branch regularly, and the fork's own `master` branch is kept identical to upstream `master`.
> The rest of this file after that section is the upstream README.

## What this branch adds

### Footer band

`Footer` (class `TVTFooter`, published on `TVirtualStringTree` and `TVirtualDrawTree`) is a band at the bottom of the tree that mirrors the header: one cell per column, aligned with the header columns and scrolled horizontally with them. It uses the header's columns for its layout and has no columns of its own. The band takes the bottom of the client area and the rows scroll above it; it follows the active VCL style or Windows theme and has a divider line between it and the data rows (not drawn with `foOwnerDraw`, so owner drawing controls the whole cell).

Footer properties:

- `Options`: `foVisible` (show the footer; off by default), `foShowImages`, `foHotTrack`, `foOwnerDraw`, `foShowButtonBorder` (a separator line on the right edge of each cell).
- `Height` (default 19, scaled with the tree's DPI), `Background`, `Font` and `ParentFont`, `Images` (with `foShowImages`, each cell shows its column's `ImageIndex` from this list).

Column property:

- `TVirtualTreeColumn.FooterText`: static text for the column's footer cell. It is published, so it can be set in the Object Inspector.

Events (on the tree):

- `OnGetFooterText`: receives the column's `FooterText` and may replace it, for example with a computed total.
- `OnFooterClick`: a footer cell was clicked.
- `OnFooterDraw`: simple owner draw of a whole footer cell (needs `foOwnerDraw`).
- `OnFooterDrawQueryElements` and `OnAdvancedFooterDraw`: advanced owner draw of individual elements (`fpeBackground`, `fpeFooterGlyph`, `fpeText`, `fpeOverlay`), in the same way as the header's advanced draw events (needs `foOwnerDraw`).

`Demos\Footer\FooterDemo.dproj` shows column totals in the footer, switching the footer options at run time, click reporting and an owner-drawn footer cell.

### Header `ParentFont` fix

In upstream Virtual Treeview, changing a property of `Header.Font` (for example `Font.Size` in the Object Inspector) leaves `Header.ParentFont` set, so the changed font is not stored in the DFM and is replaced by the tree's font again. In this branch, changing the header font clears `Header.ParentFont`, the same way `TControl.Font` and `ParentFont` behave. The footer's `Font` and `ParentFont` work the same way.

### Compatibility with upstream

- Forms that set any footer property or event (including a column's `FooterText`) report "property does not exist" errors when loaded with upstream Virtual Treeview.
- The header stream version is 7 (upstream: 6), because each column's `FooterText` is now saved with the column. Header layouts saved with `Header.SaveToStream` by this branch cannot be read by upstream Virtual Treeview; layouts saved by upstream still load here.

## About Virtual Treeview

Virtual Treeview is a Delphi treeview control built from ground up. Many years of development made it one of the most flexible and advanced tree controls available today. Virtual Treeview starts off with the claim to improve many aspects of existing solutions and introduces some new technologies and principles which were not available before.

## Help Needed: Any volunteer that takes care about **C++ Builder** bugs and packages?

I don't use C++ Builder and my experience with it is very limited. This makes it difficult to take care about bugs that are reported in C++ Builder and to maintain the C++ Builder packages. I would be great if someone would volunteer to do this.

## Downloads

[**V8** official release](https://github.com/JAM-Software/Virtual-TreeView/releases/latest) for **RAD Studio 10 to 13** which includes some **[breaking changes](https://github.com/JAM-Software/Virtual-TreeView/wiki/Breaking-Changes-in-V8)**.

[**V7.6.x**](https://github.com/JAM-Software/Virtual-TreeView/releases/tag/V7.6.6) for **Delphi XE3 to XE8**.

An experimental **FireMonkey** port can be found here: [livius2/Virtual-TreeView](https://github.com/livius2/Virtual-TreeView)

A port to **Lazarus / FPC** can be found here: [salvadorbs/VirtualTreeView-Lazarus](https://github.com/salvadorbs/VirtualTreeView-Lazarus)

For a **Delphi XE2** compatible fork see: [Fr0sT-Brutal/VirtualTreeView_mod/tree/fr0st_xe2](https://github.com/Fr0sT-Brutal/VirtualTreeView_mod/tree/fr0st_xe2)

**V5.5.3** for **Delphi 7 to XE2**: [Download](https://github.com/JAM-Software/Virtual-TreeView/releases/download/V5.5.3/VirtualTreeViewV5.5.3.zip)

**V6 latest stable version** tested on Windows XP/2003 support: [GitHub](https://github.com/Virtual-TreeView/Virtual-TreeView/archive/V6_stable.zip)

For installation instruction see the "INSTALL.TXT" file in the ZIP. [Delphinus](http://memnarch.bplaced.net/blog/2015/08/delphinus-packagemanager-for-delphi-xe-and-newer/)-Support was added.

### Technical Support

Please do not contact developers or JAM Software for technical support. Please try to get support from the community e.g. at [Stack Overflow](http://stackoverflow.com/search?q=%22virtual+treeview%22), [Delphi Pages](http://www.delphipages.com/), [Delphi Praxis](http://www.delphipraxis.net/141465-virtual-treeview-tutorials-mit-beispielen.html) or [Embarcadero forums](https://forums.embarcadero.com/). Please do not use the issue tracker for getting support, only for reporting true bugs (see below).

## Reporting Bugs

First of all, please make sure you are using the **latest official version**. When **[reporting a bug](https://github.com/Virtual-TreeView/Virtual-TreeView/issues)** please attach a **sample** project as ZIP-file that allows us to quickly reproduce the bug. This can also be one of the demo projects that come with Virtual Treeview, modified to show the bug. If only small changes are required, a description is sufficient how a demo projects needs to be changed in order to replicate the bug. Please follow [best practices for good bug reports](https://www.softwaretestinghelp.com/how-to-write-good-bug-report/).

If you already have a solution, please supply a patch file or make a pull request. If you used a previous version that did not have the bug, please include this version number in your report.

## Feature Requests

We currently focus on reducing the number of reported bugs and getting Virtual Treeview stable. Feature Requests will most likely not processed at the moment. We are only going to process enhancement requests if the new feature is of general interest and a source code patch based on the latest SVN revision is attached to the report. Please mark feature requests with the flag "Enhancement".

## Contributors

If you want to contribute, you are welcome. We always look for help, not only for the development of the Virtual Treeview control itself, but also for maintaining the sample projects, the help or the wiki. Please send an email to: joachim(dot)marder(a)gmail.com

## License

Virtual Treeview is published under a double license: MPL 1.1 and LGPL 2.1 with static linking exception as described here: <http://wiki.freepascal.org/modified_LGPL>

## New project owner

JAM Software took Virtual Treeview under its wing in 2014, but not much will change besides the homepage and download location.

## Running Tests

### From RAD Studio IDE

- Open "Tests\Tests.dproj"
- Run the project
- Use command line option --run to run individual tests

### From Command Line

```cmd
# Build  tests on console
RsVars.bat
MsBuild.exe /property:Platform=Win64 /p:Config=Console Tests\Tests.dproj

# Run all unit tests on console after build
Tests\Tests.exe

# Example how to run specific unit tests on console
Tests\ShellBrowser.Tests.exe --run:
```
