# BZN VISOR — User Guide

VISOR is a tactical-vision overlay: wear an approved helmet/headset (or crew an
approved vehicle) to see IFF tags on friendlies and Zeus-marked hostiles.

This guide covers everything a player will encounter in-game. **Keep it updated
whenever a user-facing function, keybind, setting, or notification is
added/changed** — that's anything that shows a hint/marker/sound, registers a
keybind, or appears in Addon Options.

## Getting equipped

VISOR activates automatically based on what you're wearing or crewing — there's
no menu to turn it "on":

- **Personal device**: wear one of the approved helmets, headsets, or goggles
  (see Addon Options → BZN VISOR → "Devices"). Grants the always-on friendly
  display. **By default, every Bzn wearable in this mod qualifies** — all
  [Bzn] FASTMT helmet variants, all [Bzn] Recon Hood variants, and the Bzn
  ESS goggle facewear.
- **Approved vehicle**: certain vehicles (Addon Options → "Approved vehicles")
  grant the always-on display to anyone mounted, regardless of headgear
  (empty by default).

> Note: CBA only applies a new default where the setting was never saved — if
> you've previously touched "Devices" in Addon Options (even leaving it
> empty), hit *Reset to Default* there to pick up the Bzn gear list.

Equipment is re-checked automatically whenever you put on/take off gear, get in
or out of a vehicle, or close your inventory — no need to reconnect or restart.

## Keybinds (Controls > Configure Addons > BZN VISOR)

| Action | Default | What it does |
|---|---|---|
| **Toggle VISOR Display** | `Alt+F8` | Turns the entire 3D overlay on/off. |
| **Toggle Friendly Markers** | `Alt+F9` | Hides/shows tags for friendly-side units only (Zeus-marked tags stay visible). |
| **Toggle Detail Mode** | *unbound — bind it yourself* | ON (default): tags show their designator text — type line, names, and role suffixes. OFF: every tag strips down to just its colour-coded IFF hexagon, no text. |

All toggles show a brief on-screen confirmation (e.g. "VISOR display: ON/OFF").

## Zeus marking ("Mark Target (VISOR)")

Target marking is entirely Zeus (curator) driven — there is no player-facing
spotting action. A Game Master places the **Mark Target (VISOR)** module
(Zeus → Modules → BZN VISOR) directly onto a unit, and a **configuration
popup** opens:

- **Up to 3 lines of context text**, each with its own colour choice —
  **Red**, **Blue**, or **Yellow** — rendered stacked under the target's red
  hex. Empty lines are skipped. Marks are only visible to players
  **personally wearing a VISOR device** (a whitelisted helmet or goggles) —
  an approved vehicle alone shows the friendly IFF picture but *not* the
  marked-target feed, so everyone needs the kit on their head to read marks.
- **Optional timer** — tick "Timed mark" and set the seconds (default 60)
  and the mark fades on its own, with a countdown on its **"MARKED | <grid>
  | Xs"** line. Untick it and the mark is **permanent**: it stays until the
  target dies (its bottom line then reads just "MARKED | <grid>").
- **CANCEL** (or ESC) closes the popup and removes the module without
  marking anything.
- If the module isn't dropped directly on a unit, VISOR looks for the nearest
  living unit within 10 m and marks that instead; if nothing is found nearby,
  the placing curator gets an on-screen feedback message.
- The mark is **broadcast once to every player connected at that moment**
  and then forgotten — no tracking, no updates, and players who join later
  won't see marks placed before they connected. Re-placing the module on the
  same unit replaces its mark (that's also how you "edit" one).
- There is no map marker for a Zeus mark — the 3D tag is the only indicator.

## Drone ("uplink") notice

When you remotely connect to a UAV/UGV through a terminal, your VISOR
tracking is **slaved to the drone's sensor feed** — not your own character's
point of view (your body stays at the terminal). A notification appears
top-right when this changes:

- **While connected**: *"Slaved to drone feed — tracking now follows the
  drone's view, not your own."* — stays on screen continuously for the entire
  time you're connected (re-asserted every second so it can't get bumped off by
  other notifications).
- **On disconnecting**: *"Restored to personal view"*, then clears after 5
  seconds.

This is informational only — the always-on display keeps working exactly the
same, just from the drone's perspective while you're connected. Friendly
drones also show **"OP: <name>"** on their tag for whoever is remotely flying
them, clearing within a couple seconds of disconnecting.

## Always-on friendly/marked display

Whenever VISOR is active (device or approved vehicle), you automatically see
3D tags over:

- **Friendly-side units** — IFF identification in a bright HALO/UNSC-style
  cyan, toggleable via the "Toggle Friendly Markers" keybind. A friendly is
  only tagged if **it is itself wearing VISOR** (a whitelisted helmet/goggles;
  for vehicles, an approved type or an equipped crew member) — an unequipped
  teammate doesn't transmit and stays invisible, the same "you need the kit"
  rule that applies to viewers. Human players and allied AI/NPCs are treated
  identically (we run PvE co-op; equipped allied NPCs are real teammates).
  Civilians stay untagged. VIP/HVT-flagged units and Zeus-marked targets are
  exempt from the equipment gate — they show regardless of gear. Tags render
  drone-feed style: a small hex anchors at chest height with a compact centred
  **"BZN INF"** type line above it and the unit's name beneath it. (Your own
  squad's health is reported separately by the fixed on-screen panel — see
  "Squad health readout" below.)
- **Vehicles** — only vehicles on the **"Approved vehicles"** whitelist show
  a full readout (type, crew/OP, engine/status). A vehicle that isn't
  whitelisted shows **just its colour-coded IFF hexagon — no text at all**.
  Whitelisted vehicles crewed by at least one human player also get the
  equivalent designator type line by chassis: **BZN AIR**, **BZN SEA**, or
  **BZN GRND** (AI-only crews keep the plain full tag). Zeus-marked, HVT-, and
  VIP-flagged vehicles are exempt from the hex-only rule — a curator/mission
  deliberately called them out, so their tag always shows in full.
- **Zeus-marked targets** — see "Zeus marking" above; shown to everyone with
  VISOR active regardless of who's actually looking at them, with the
  curator's colour-coded context lines under the red hex.

Tags show unit status where relevant (e.g. armed/unarmed, engine on/off,
deceased/destroyed) alongside the grid reference, plus an **"OP: ..."** line
naming who's running the platform:

- **Launcher carriers** — hostile/neutral infantry packing an AT/AA launcher
  always get a distinct, individual tag reading **"ARMED | LAUNCHER"**
  highlighted red like a HOSTILE tag — that's your priority-threat callout.
- **Friendly role suffixes** — friendlies keep their name on the tag, with
  **exactly one** compact role suffix, picked by priority (a squad lead
  who's also a medic just reads SQL): **SQL** > **FTL** > **Med** >
  **Expl** > **Engi** > **AT**.
  - **" - SQL"** — squad lead (Arma's own group-leader designation; lone
    one-man groups don't count).
  - **" - FTL"** — fire team lead, designated via **ACE Team Management**:
    interact with a teammate (or self-interact) → Team Management →
    **"Designate Fire Team Lead"** (toggle; visible to everyone).
  - **" - Med"** — medic permissions (ACE medic class or vanilla medic trait).
  - **" - Expl"** — explosive specialist (ACE EOD or vanilla trait).
  - **" - Engi"** — engineer permissions (ACE engineer or vanilla trait).
  - **" - AT"** — carrying a launcher.
- **HVTs** — a unit the mission has flagged as a priority kill target
  (mission-side, e.g. in its init field: `this setVariable
  ["BZN_visor_HVT", true, true];` — the trailing `true` is the public-
  broadcast flag, required so every client sees the flag, not just the
  machine the unit is local to) gets a distinct violet **"HVT - ELIMINATE"** tag in
  place of the usual type label, so it never gets lost among ordinary
  contacts. (Distinct from VIP below — HVT doesn't carry any "keep them
  alive" connotation either way.)
- **VIPs** — a unit the mission has flagged as someone who must stay on the
  board (mission-side: `this setVariable ["BZN_visor_VIP", true, true];`
  — same public-broadcast requirement as HVT above) gets a
  distinct royal-blue **"VIP - PROTECT"** tag (or **"VIP - TAKE ALIVE"** if
  they're on a side hostile to you — i.e. capture, don't kill) in place of
  the usual type label, so you always know at a glance who not to put down.
  Like launcher carriers, HVTs and VIPs always render with full detail
  regardless of whether you're looking at them.

Ordinary infantry always render as the **compact designator** — hex
bracketed by the type line and **name** (with role suffixes), or a single
**ARMED**/**UNARMED**/**LAUNCHER** word for hostiles and neutrals. Distance,
grid reference, and the fuller status lines never show for rank-and-file
infantry — that's deliberate: the designator is the whole picture, and the
detailed stack is reserved for the categories below that actually warrant it.

**Zeus-marked targets, hostile/neutral launcher carriers, HVT-flagged units**
(mission-side: `this setVariable ["BZN_visor_HVT", true, true];`), **VIPs**
(see "HVT"/"VIP - PROTECT/TAKE ALIVE" above), **and all vehicles, aircraft,
ships, and drones** are exempt from this — they always show in full, since
hiding a mark's context, a priority individual, or a platform's crew/operator
detail would defeat the point. Friendly launcher carriers aren't a threat
that needs constant tracking though, so they gate down like any other
teammate — their reduced tag keeps the **" - AT"** name suffix so you don't
lose track of who's carrying the team's AT/AA. If you'd rather have a
completely clean picture — nothing but the colour-coded hexagons — bind and
use **Toggle Detail Mode** (see Keybinds above) to switch all tag text off;
toggle it back on to return to the full designators.

- **Friendly drones** show **"OP: <name>"** for whoever is remotely flying it
  through a terminal — the tag clears within a couple seconds of them
  disconnecting.
- **Other crewed vehicles** show **"OP: <name> (D/G/C)"** for whoever's in the
  Driver, Gunner, and/or Commander seats (role letters shown per person, e.g.
  "John (D/G)" if they're filling more than one), plus **"P: <count>"** for
  everyone else aboard (turret/cargo) — named individually would be unreadable
  on a full vehicle, so passengers are summarized as a simple headcount.

## Squad health readout (PoC)

**Proof of concept** — while VISOR is active, a small **fixed on-screen
panel** (default: bottom-right corner) lists you and every member of your
current squad (your `group`) with a colour-coded health state, driven by ACE
medical (cardiac arrest, active bleeding, and unconsciousness — falls back to
vanilla damage/lifeState if ACE medical isn't running). It's completely
separate from the 3D IFF overlay — nothing about your squadmates' world tags
changes with their health.

Under a light-blue **SQUAD** header, one line per member:

- **Green ■ Name** — healthy.
- **Yellow ■ Name - WND** — **actively bleeding or unconscious**. A downed
  teammate reads WND even once they've been bandaged/stabilised, so a
  still-unconscious body never shows OK. Pain, bruises, and already-bandaged
  damage on an *awake* squadmate don't trigger it — a patched-up, conscious
  teammate reads OK again.
- **Red ■ Name - CRIT** — **cardiac arrest** — the "drop everything, CPR
  now" signal. Takes precedence over WND: an arrested teammate is also
  unconscious, but they show CRIT, not yellow.
- **Grey ■ Name - KIA** — dead (grey rather than black so the line stays
  readable over a dark scene — the panel has no background).

A squadmate who dies stays listed as KIA even after they leave your group
(which happens automatically on death), so the roster doesn't silently shrink
mid-firefight — but only for about a minute, after which the KIA line ages
out on its own rather than lingering forever. The panel only shows while
VISOR itself is active (approved device/vehicle + the display toggle on) and
hides entirely when you're dead.

Three personal Addon Options control it (see table below): **"Squad health
panel (standalone)"** turns VISOR's own corner panel on/off, **"Squad health
indicator position"** moves that panel between the four screen corners
(bottom-left, bottom-right, top-left, top-right), and **"Squad health → DUI
Squad Radar"** controls the DUI integration below. The panel and the DUI
integration are fully independent — run either, both, or neither.

### DUI (Squad Radar) integration

If you run [diwako's DUI - Squad Radar](https://github.com/diwako/diwako_dui)
alongside VISOR, an **alive** squadmate's entry in DUI's list (and their 3D
nametag) gains a colour-coded status suffix — **"Name - OK"** (green),
**"Name - WND"** (yellow), or **"Name - CRIT"** (red) — including downed and
cardiac-arrest casualties, so the list stays informative when someone drops.
The name itself keeps DUI's normal unit colour. Healthy members get an
explicit green **OK** (unlike VISOR's own panel, DUI's list has no
colour-coded square, so "no suffix" there would read as "no data").

When a member **dies**, the suffix is stripped and DUI shows their plain name.
That takes a little extra work: DUI's nametag cache loop skips dead units, so
it would otherwise freeze the last status ("- OK"/"- WND") on the corpse's 3D
nametag forever — VISOR repairs DUI's cache at the death instant so the body
reads plainly. **KIA** is shown on VISOR's own standalone panel instead. This
works through DUI's documented `diwako_dui_main_customName` hook, using the
member's real name (ACE_Name/name) as the base; the override is also cleared
when they leave the squad or the option is switched off. Does nothing when DUI
isn't loaded. (Note: while
a member is in your squad this overrides any custom DUI name a mission may
have set for them — a deliberate trade for robustness.) If you prefer DUI's
list as your only squad readout, turn VISOR's standalone panel off and leave
this integration on.

## Addon Options ("BZN VISOR" category)

| Setting | Who controls it | What it controls |
|---|---|---|
| Devices (always-on) | Mission/server (forced) | Which helmet/goggle classnames grant the personal VISOR device. Defaults to every Bzn wearable in this mod (FASTMT helmets, Recon Hoods, ESS goggle facewear). |
| Infantry fade range (m) | **You** (personal, per-player) | How far out infantry tags stay visible — they fade with distance and disappear around this range (default 1000 m; 100–3000 m slider). |
| Vehicle fade range (m) | **You** (personal, per-player) | Same for vehicle/aircraft/ship tags (default 5000 m; 100–10000 m slider) — higher than infantry so friendly air keeps its IFF at realistic contact ranges. |
| Tag shrink range (m) | **You** (personal, per-player) | Tags shrink progressively with zoom-adjusted distance, bottoming out at this range (default 5000 m; 500–10000 m slider). Zooming an optic onto a contact counts as being closer, growing its tag back. |
| Tag minimum scale | **You** (personal, per-player) | How small a tag gets at/beyond the shrink range (default 0.5 = half size; 0.1–1 slider). Set to 1 to disable distance shrinking entirely. |
| Approved vehicles | Mission/server (forced) | Which vehicle classnames grant VISOR to anyone mounted, regardless of headgear. |
| Squad health panel (standalone) | **You** (personal, per-player) | Turns VISOR's own fixed on-screen squad health panel (see "Squad health readout" above) on/off. Independent of the DUI integration. On by default. |
| Squad health indicator position | **You** (personal, per-player) | Which screen corner the standalone panel sits in (bottom-left, bottom-right, top-left, top-right; default bottom-right). Top-right can momentarily overlap VISOR hint notifications. |
| Squad health → DUI Squad Radar | **You** (personal, per-player) | Appends a colour-coded status ("Name - OK/WND/CRIT/KIA") to squadmates' names in DUI's list when DUI is loaded (see "DUI integration" above). On by default; harmless without DUI. |

The whitelist settings (devices/vehicles) are forced server-wide so everyone
plays by the same rules — explains why VISOR may behave differently between
servers. The squad health panel settings are purely personal UI preferences
and stay local, per-player choices. (The Zeus mark timer is set per-mark in
the module's popup, not in Addon Options.)

---

### Maintenance note for contributors
When you add or change anything a player can see or trigger — a keybind,
hint/notification, tag/HUD element, Zeus module, or Addon Option — add or
update the relevant section above so this stays a complete, accurate
reference for end users.
