# BZN TacVis — User Guide

TacVis is a tactical-vision overlay: wear an approved helmet/headset (or crew an
approved vehicle) to see IFF tags on friendlies and team-spotted hostiles, mark
targets for your team, scan for radar contacts, and run short-range CQC threat
detection.

This guide covers everything a player will encounter in-game. **Keep it updated
whenever a user-facing function, keybind, setting, or notification is
added/changed** — that's anything that shows a hint/marker/sound, registers a
keybind or scroll action, or appears in Addon Options.

## Getting equipped

TacVis activates automatically based on what you're wearing or crewing — there's
no menu to turn it "on":

- **Personal device**: wear one of the approved helmets, headsets, or goggles
  (see Addon Options → BZN TacVis → "Devices"). Grants the always-on friendly
  display, the Spot Target action/keybind, and hostile-civilian threat alerts.
- **CQC device**: a smaller subset of devices (Addon Options → "CQC devices")
  additionally grants the "Toggle CQC" scroll-wheel option.
- **JTAC device**: a separate, independent whitelist (Addon Options → "JTAC
  devices") grants the always-on JTAC SITREP overlay (see below) — typically
  reserved for whoever's running the team's intel picture, rather than handed
  to everyone with a personal device.
- **Approved vehicle**: certain vehicles (Addon Options → "Approved vehicles")
  grant the always-on display and Spot Target to anyone mounted, regardless of
  headgear. If the vehicle also has an active radar sensor, its crew additionally
  gets the radar contact scan.

Equipment is re-checked automatically whenever you put on/take off gear, get in
or out of a vehicle, or close your inventory — no need to reconnect or restart.

## Keybinds (Controls > Configure Addons > BZN TacVis)

| Action | Default | What it does |
|---|---|---|
| **Toggle TacVis Display** | `Alt+F8` | Turns the entire 3D overlay on/off. |
| **Toggle Friendly Markers** | `Alt+F9` | Hides/shows tags for friendly-side units only (hostile/spotted tags stay visible). |
| **Toggle Detail View** | *unbound — bind it yourself* | Overrides "looked at" tag gating (see below) — while active, every infantry tag always shows in full, not just whichever one's under your crosshair. |
| **Spot Target** | *unbound — bind it yourself* | Marks the hostile under your reticle/optic/feed for your whole team (see "Spotting" below). Works on foot, in vehicle turrets, and while remotely piloting a UAV — the only reliable trigger while piloting, since the scroll-wheel menu can be unreachable there. |

All three toggles show a brief on-screen confirmation (e.g. "TacVis display: ON/OFF").

## Scroll-wheel (self-interaction) actions

These appear in your scroll-wheel menu only while you're equipped/crewed
appropriately, and only while their conditions are met:

- **Spot Target** — same effect as the keybind above. The menu entry itself is
  always there whenever your device is active and you're not on cooldown — but
  using it still requires you to actually be aiming through an optic, a turret/
  gunner sight, or a connected UAV feed (drones always count — the feed *is*
  your sight the moment you connect); otherwise you'll see **"Aim through
  optics to spot"** and nothing gets marked. Can be hidden entirely via Addon Options
  if you prefer to rely solely on the keybind (Addon Options → "Show 'Spot
  Target' in scroll menu").
- **Toggle CQC** — starts/stops a ~30-second close-quarters scan (see "CQC mode"
  below). Has a randomized cooldown after each use.

## Spotting

Aim through an optic, a turret/gunner sight, or a connected UAV feed (drones
always count — the feed *is* your sight from the moment you connect, nothing
extra to do), rest your crosshair precisely on a hostile, and trigger
**Spot Target** (scroll-wheel or keybind) to mark them for your entire team:

- A **"SPOTTED | <grid> | Xs"** tag appears over the target for everyone with
  TacVis active, counting down the seconds remaining.
- If you're not actually aiming through a valid sight/feed when you trigger it,
  you'll see **"Aim through optics to spot"** and nothing gets marked.
- The mark **fades on its own** after a while (default ~35s) — but **resets
  every time any teammate with a TacVis device has a clear line of sight on the
  target**, so a target your team is actively watching stays marked
  indefinitely, while one that breaks contact with the whole team fades out
  naturally.
- Spotting has a short cooldown between uses.

## Drone ("uplink") notice

When you remotely connect to a UAV/UGV through a terminal, your TacVis
tracking/spotting is **slaved to the drone's sensor feed** — not your own
character's point of view (your body stays at the terminal). A notification
appears top-right when this changes:

- **While connected**: *"Slaved to drone feed — tracking now follows the
  drone's view, not your own."* — stays on screen continuously for the entire
  time you're connected (re-asserted every second so it can't get bumped off by
  other notifications).
- **On disconnecting**: *"Restored to personal view"*, then clears after 5
  seconds.

This is informational only — Spot Target and the always-on display keep working
exactly the same, just from the drone's perspective while you're connected.

## CQC mode ("Toggle CQC")

A short-range threat-detection mode for close-quarters work:

- Scans roughly a 50 m bubble around you for up to 10 of the nearest
  living units (any side) and tags them — **for your eyes only**: unlike
  Spot Target/JTAC, CQC contacts are never shared with your team, so a
  "<t color='#ff8c00'>TACVIS CQC</t>" hint reading **"Personal scan — not
  shared with your team"** rides along under the countdown as a reminder.
- Runs for **30 seconds**, with a beep each second and an orange countdown
  shown top-right (**"TACVIS CQC — Active: Xs"**) — orange specifically to
  set it apart from JTAC's amber SITREP and CQC's own red cooldown/ready
  hints, reinforcing that this is *your* personal view, not shared intel.
- Stops automatically when the timer runs out, when you toggle it off again, or
  if you remove your CQC device mid-scan.
- After stopping, the action goes on a **randomized 60–180 second cooldown**
  before you can use it again.

## JTAC SITREP overlay

Whenever you're wearing a JTAC-whitelisted helmet/headset/goggle (Addon
Options → "JTAC devices" — its own separate, independent whitelist, NOT the
same list that grants the always-on display/Spot Target; see "Getting
equipped" above), a persistent top-right overlay headed **"TACVIS JTAC"**
gives you a running,
grid-by-grid breakdown of every contact your team currently has eyes on —
team-spotted hostiles and shared radar contacts alike, refreshed about every
2 seconds:

- **"GRID 045123 — INF x4 (1x LAUNCHER) | GND x2 | AIR x1"** — one line per
  occupied grid square, nearest to you first: how many infantry are in that
  square (and how many of *those* are carrying a launcher — the same
  priority-threat callout the individual 3D tags highlight), split into
  **GND** (cars/armour), **AIR** (aircraft/helicopters/drones), and **WTR**
  (ships/boats) so armour-in-the-open and an inbound chopper read as
  distinctly different calls — only the categories actually present in a
  square are listed.
- Squares with nothing reported show **"No contacts reported"** instead of an
  empty list.
- Hostile-civilian threat-watch alerts (see below) are deliberately excluded —
  those are personal proximity warnings about armed civilians nearby, not the
  kind of organised, location-based picture a JTAC report aggregates.

Like the drone-uplink notice below, this re-asserts itself continuously while
your device is active, so it can get momentarily bumped by other hints (CQC's
countdown, the uplink notice, vanilla system hints) — it simply reclaims the
slot on its next refresh a moment later.

## Always-on friendly/hostile display

Whenever TacVis is active (device, CQC gear, or approved vehicle), you
automatically see 3D tags over:

- **Friendly-side units** — IFF identification, toggleable via the "Toggle
  Friendly Markers" keybind. Only **player-controlled** friendlies (and any
  side's **VIP**-flagged units — see below) get tagged this way; rank-and-file
  friendly-side and civilian-side AI are background noise and stay untagged,
  so the display reflects who actually matters tactically rather than every
  bot teammate or bystander on the map.
- **Team-spotted hostiles** — see "Spotting" above; shown to everyone
  regardless of who originally marked them.
- **Radar contacts** — if you're crewing a vehicle with an active radar sensor,
  contacts your radar picks up are shared with your whole team and shown to
  anyone with TacVis active, for as long as the contact stays live.
- **Hostile-civilian threat alerts** — TacVis device users get a warning marker
  when an armed civilian-side unit is detected nearby.

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
  ["BZN_tacvis_HVT", true, true];` — the trailing `true` is the public-
  broadcast flag, required so every client sees the flag, not just the
  machine the unit is local to) gets a distinct violet **"HVT - ELIMINATE"** tag in
  place of the usual type label, so it never gets lost among ordinary
  contacts. (Distinct from VIP below — HVT doesn't carry any "keep them
  alive" connotation either way.)
- **VIPs** — a unit the mission has flagged as someone who must stay on the
  board (mission-side: `this setVariable ["BZN_tacvis_VIP", true, true];`
  — same public-broadcast requirement as HVT above) gets a
  distinct sky-blue **"VIP - PROTECT"** tag (or **"VIP - TAKE ALIVE"** if
  they're on a side hostile to you — i.e. capture, don't kill) in place of
  the usual type label, so you always know at a glance who not to put down.
  Like launcher carriers, HVTs and VIPs are never folded into a squad summary
  tag and always render with full detail regardless of whether you're looking
  at them.

When several same-side **infantry** are bunched close together *and* far
enough away from you, their tags collapse into a single summary —
**"INFANTRY x5 | SPOTTED | grid | Xs | ARMED | HOSTILE"** — instead of
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
they are is), and, for spotted hostiles, the same small drop-off countdown
described above so a mark about to fade doesn't catch you off guard even at
this reduced level. Distance, grid reference, and the fuller SPOTTED/RADAR/
THREAT line are still dropped here — that's clutter you don't need until
you're looking right at someone, where the full tactical/hover view brings
it all back. Only the *one* tag you're directly looking at —
within a few degrees of your sightline, working through ironsights, scopes,
turrets, and UAV feeds alike — expands to show everything (type, grid/status
line, HOSTILE/INJURED detail, and — for spotted hostiles — a small standalone
countdown under the ARMED/HOSTILE line so you can tell at a glance when a
mark is about to fade). Look away and it collapses back down; look at someone
else and that one expands instead — only one tag is ever expanded at a time.

**Hostile/neutral launcher carriers, HVT-flagged units** (mission-side:
`this setVariable ["BZN_tacvis_HVT", true, true];`), **VIPs** (see "HVT"/"VIP -
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

## Addon Options ("BZN TacVis" category)

| Setting | Who controls it | What it controls |
|---|---|---|
| Devices (always-on + spot) | Mission/server (forced) | Which helmet/goggle classnames grant the personal TacVis device. |
| CQC devices | Mission/server (forced) | Which classnames additionally grant the CQC scroll-wheel toggle. |
| JTAC devices | Mission/server (forced) | Which classnames grant the always-on JTAC SITREP overlay — its own independent whitelist, separate from the main device list above (leave empty to restrict it to nobody). |
| Approved vehicles | Mission/server (forced) | Which vehicle classnames grant TacVis to anyone mounted, regardless of headgear. |
| Show 'Spot Target' in scroll menu | **You** (personal, per-player) | Whether the scroll-wheel Spot Target entry appears alongside the keybind for *you* (the keybind always works either way). Set it in your own Addon Options — the server can't override this one. |
| Tag clustering range (m) | **You** (personal, per-player) | How far away a bunch of same-side infantry needs to be before *your* display collapses them into one summary tag while on foot/in ground vehicles (default 100m; 0–500m slider). Vehicles/air/sea/drones and launcher carriers are never collapsed this way. Purely a personal declutter preference — doesn't change what anyone else sees or any gameplay balance. |
| Tag clustering range, air/drone (m) | **You** (personal, per-player) | Same idea, but used instead whenever you're aircrew or slaved to a UAV/UGV feed — looking down from altitude bunches infantry together at much greater distances, hence the much higher default (2 km; 0–5 km slider). |

The whitelist settings (devices/CQC devices/vehicles) are forced server-wide so
everyone plays by the same equipment rules — explains why TacVis may behave
differently between servers. The scroll-menu toggle is purely a personal UI
preference and stays a local, per-player choice.

---

### Maintenance note for contributors
When you add or change anything a player can see/hear/trigger — a keybind,
scroll action, hint/notification, marker, sound cue, cooldown, or Addon Option —
add or update the relevant section above so this stays a complete, accurate
reference for end users.
