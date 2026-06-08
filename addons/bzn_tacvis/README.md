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
| **Spot Target** | *unbound — bind it yourself* | Marks the hostile under your reticle/optic/feed for your whole team (see "Spotting" below). Works on foot, in vehicle turrets, and while remotely piloting a UAV — the only reliable trigger while piloting, since the scroll-wheel menu can be unreachable there. |

Both toggles show a brief on-screen confirmation (e.g. "TacVis display: ON/OFF").

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
  living units (any side) and tags them.
- Runs for **30 seconds**, with a beep each second and a countdown shown
  top-right (**"TACVIS CQC — Active: Xs"**).
- Stops automatically when the timer runs out, when you toggle it off again, or
  if you remove your CQC device mid-scan.
- After stopping, the action goes on a **randomized 60–180 second cooldown**
  before you can use it again.

## Always-on friendly/hostile display

Whenever TacVis is active (device, CQC gear, or approved vehicle), you
automatically see 3D tags over:

- **Friendly-side units** — IFF identification, toggleable via the "Toggle
  Friendly Markers" keybind.
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
| Approved vehicles | Mission/server (forced) | Which vehicle classnames grant TacVis to anyone mounted, regardless of headgear. |
| Show 'Spot Target' in scroll menu | **You** (personal, per-player) | Whether the scroll-wheel Spot Target entry appears alongside the keybind for *you* (the keybind always works either way). Set it in your own Addon Options — the server can't override this one. |

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
