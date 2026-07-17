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
  display.
- **Approved vehicle**: certain vehicles (Addon Options → "Approved vehicles")
  grant the always-on display to anyone mounted, regardless of headgear.

Equipment is re-checked automatically whenever you put on/take off gear, get in
or out of a vehicle, or close your inventory — no need to reconnect or restart.

## Keybinds (Controls > Configure Addons > BZN VISOR)

| Action | Default | What it does |
|---|---|---|
| **Toggle VISOR Display** | `Alt+F8` | Turns the entire 3D overlay on/off. |
| **Toggle Friendly Markers** | `Alt+F9` | Hides/shows tags for friendly-side units only (Zeus-marked tags stay visible). |
| **Toggle Detail View** | *unbound — bind it yourself* | Overrides "looked at" tag gating (see below) — while active, every infantry tag always shows in full, not just whichever one's under your crosshair. |

All toggles show a brief on-screen confirmation (e.g. "VISOR display: ON/OFF").

## Zeus marking ("Mark Enemy (VISOR)")

Enemy marking is entirely Zeus (curator) driven — there is no player-facing
spotting action. A Game Master places the **Mark Enemy (VISOR)** module
(Zeus → Modules → BZN VISOR) directly onto a unit to mark it:

- The target gets a **"MARKED | <grid> | Xs"** tag, visible to everyone with
  VISOR active for the configured duration (Addon Options → "Zeus mark
  duration (s)", default 60s), counting down the seconds remaining.
- If the module isn't dropped directly on a unit, VISOR looks for the nearest
  living unit within 10 m and marks that instead; if nothing is found nearby,
  the placing curator gets an on-screen feedback message and the module
  removes itself without marking anything.
- The mark **fades on its own** once its timer runs out — there is no
  line-of-sight refresh mechanic; re-place the module on the same target to
  refresh/extend the mark.
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

- **Friendly-side units** — IFF identification in a pale HALO/UNSC-style
  light blue, toggleable via the "Toggle Friendly Markers" keybind. Only
  **player-controlled** friendlies (and any side's **VIP**-flagged units —
  see below) get tagged this way; rank-and-file friendly-side and
  civilian-side AI are background noise and stay untagged, so the display
  reflects who actually matters tactically rather than every bot teammate or
  bystander on the map. (Your own squad's health is reported separately by
  the fixed on-screen panel — see "Squad health readout" below — so squad
  members follow these same 3D-tag rules as everyone else.)
- **Zeus-marked enemies** — see "Zeus marking" above; shown to everyone with
  VISOR active regardless of who's actually looking at them.

Tags show unit status where relevant (e.g. armed/unarmed, engine on/off,
deceased/destroyed) alongside the grid reference, plus an **"OP: ..."** line
naming who's running the platform:

- **Launcher carriers** — infantry packing an AT/AA launcher always get a
  distinct, individual tag instead of being folded into the rifleman crowd
  (or a squad summary). Hostiles read **"ARMED | LAUNCHER"** highlighted red
  like a HOSTILE tag — that's your priority-threat callout. Friendly launcher
  gunners read a plain white **"LAUNCHER"** instead — no need for a threat
  colour, just enough to tell who on your team is carrying the AT/AA.
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
  Like launcher carriers, HVTs and VIPs are never folded into a squad summary
  tag and always render with full detail regardless of whether you're looking
  at them.

When several same-side **infantry** are bunched close together *and* far
enough away from you, their tags collapse into a single summary —
**"INFANTRY x5 | MARKED | grid | Xs | ARMED | HOSTILE"** — instead of
overlapping individually. (Vehicles, aircraft, ships, and drones are never
grouped this way — there are rarely enough of them in one spot to overlap,
and their per-unit operator/crew/status detail is exactly what you want to
keep visible. Launcher carriers are excluded too — see above.) How far away
"far enough" is is your call: see **"Tag clustering range"** in Addon Options
below (set it low to declutter sooner, or max it out to always see every
contact's full tag). Looking down from a plane/heli or a connected drone feed
bunches infantry together on screen at much greater distances than on the
ground, so a separate **"Tag clustering range, air/drone"** slider (default
2 km) is used automatically whenever you're aircrew or slaved to a UAV/UGV.
Smaller bunches that don't meet the grouping threshold, or anything closer
than the active clustering range, still render individually — just nudged
apart vertically so overlapping pairs/trios stay readable.

Clustering helps at range, but a close-quarters firefight can still stack
full tags on every nearby rifleman. So up close, ordinary infantry render
**reduced** — hex and a single status word (**ARMED**/**UNARMED**/
**LAUNCHER** for hostiles and neutrals, or simply their **name** for
friendlies — knowing whether a teammate is "armed" isn't useful, knowing who
they are is), and, for marked hostiles, the same small drop-off countdown
described above so a mark about to fade doesn't catch you off guard even at
this reduced level. Distance, grid reference, and the fuller MARKED line are
still dropped here — that's clutter you don't need until you're looking
right at someone, where the full tactical/hover view brings it all back.
Only the *one* tag you're directly looking at — within a few degrees of your
sightline, working through ironsights, scopes, turrets, and UAV feeds alike —
expands to show everything (type, grid/status line, HOSTILE/INJURED detail,
and — for marked hostiles — a small standalone countdown under the
ARMED/HOSTILE line so you can tell at a glance when a mark is about to fade).
Look away and it collapses back down; look at someone else and that one
expands instead — only one tag is ever expanded at a time.

**Hostile/neutral launcher carriers, HVT-flagged units** (mission-side:
`this setVariable ["BZN_visor_HVT", true, true];`), **VIPs** (see "HVT"/"VIP -
PROTECT/TAKE ALIVE" above), **and all vehicles, aircraft, ships, and drones**
are exempt from this — they always show in full, since hiding a priority
individual or a platform's crew/operator detail would defeat the point.
Friendly launcher carriers aren't a threat that needs constant tracking
though, so they gate down like any other teammate — their reduced tag still
reads **"LAUNCHER"** so you don't lose track of who's carrying the team's
AT/AA. The exempt categories above are also never folded into a clustered
squad summary, for the same reason. If you'd rather see everything in full
all the time, bind and use **Toggle Detail View** (see Keybinds above) to
permanently override the gating.

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
medical (bleeding, pain, unconsciousness, cardiac arrest — falls back to
vanilla damage/lifeState if ACE medical isn't running). It's completely
separate from the 3D IFF overlay — nothing about your squadmates' world tags
changes with their health.

Under a light-blue **SQUAD** header, one line per member:

- **Green ■ Name** — healthy.
- **Yellow ■ Name WOUNDED** — damaged (bleeding, in pain, or lightly hurt).
- **Red ■ Name CRITICAL** — critical (unconscious or in cardiac arrest).
- **Grey ■ Name KIA** — dead (grey rather than black so the line stays
  readable over a dark scene — the panel has no background).

A squadmate who dies stays listed as KIA even after they leave your group
(which happens automatically on death), for as long as their body exists —
the roster doesn't silently shrink mid-firefight. The panel only shows while
VISOR itself is active (approved device/vehicle + the display toggle on) and
hides entirely when you're dead.

Two personal Addon Options control it (see table below): **"Squad health
indicator (PoC)"** turns the panel on/off, and **"Squad health indicator
position"** moves it between the four screen corners (bottom-left,
bottom-right, top-left, top-right).

## Addon Options ("BZN VISOR" category)

| Setting | Who controls it | What it controls |
|---|---|---|
| Devices (always-on) | Mission/server (forced) | Which helmet/goggle classnames grant the personal VISOR device. |
| Approved vehicles | Mission/server (forced) | Which vehicle classnames grant VISOR to anyone mounted, regardless of headgear. |
| Zeus mark duration (s) | Mission/server (forced) | How long a unit marked via the Zeus "Mark Enemy (VISOR)" module stays tagged "MARKED" for everyone with VISOR, before the mark expires (default 60s; 10–600s slider). |
| Squad health indicator (PoC) | **You** (personal, per-player) | Turns the fixed on-screen squad health panel (see "Squad health readout" above) on/off. On by default. |
| Squad health indicator position | **You** (personal, per-player) | Which screen corner the squad health panel sits in (bottom-left, bottom-right, top-left, top-right; default bottom-right). Top-right can momentarily overlap VISOR hint notifications. |
| Tag clustering range (m) | **You** (personal, per-player) | How far away a bunch of same-side infantry needs to be before *your* display collapses them into one summary tag while on foot/in ground vehicles (default 100m; 0–500m slider). Vehicles/air/sea/drones and launcher carriers are never collapsed this way. Purely a personal declutter preference — doesn't change what anyone else sees or any gameplay balance. |
| Tag clustering range, air/drone (m) | **You** (personal, per-player) | Same idea, but used instead whenever you're aircrew or slaved to a UAV/UGV feed — looking down from altitude bunches infantry together at much greater distances, hence the much higher default (2 km; 0–5 km slider). |
| Debug mode | **You** (personal, per-player) | Shows a live marked-list hint (expiry values per target) and logs each AddSpot call to RPT. |

The whitelist settings (devices/vehicles) and the Zeus mark duration are forced
server-wide so everyone plays by the same rules — explains why VISOR may
behave differently between servers. The clustering sliders and debug mode are
purely personal UI preferences and stay local, per-player choices.

---

### Maintenance note for contributors
When you add or change anything a player can see/hear/trigger — a keybind,
scroll action, hint/notification, marker, sound cue, cooldown, or Addon Option —
add or update the relevant section above so this stays a complete, accurate
reference for end users.
