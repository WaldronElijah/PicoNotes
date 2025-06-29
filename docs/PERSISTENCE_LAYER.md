# Section 3: The Persistence Layer

This document outlines the strategy for storing data within PicoNotes. It summarizes the reasoning for choosing a local database and backend service and describes how data will be synchronized between them.

## 3.1 Local Database Selection: The Stability vs. Hype Dilemma

A robust local database is required to provide offline access and power features like the per-note Media Bank.

### Analysis of Options

* **Hive** and **Isar** – Fast and simple but largely maintained by the community. Relying on community forks introduces uncertainty for a production app.
* **Drift** – A reactive ORM built on top of SQLite. SQLite is extremely battle-tested and Drift's type-safe API integrates well with Riverpod and provides tooling for schema migrations.

### Recommendation

Drift is the preferred local database. It offers long-term stability via SQLite while supporting a modern developer experience in Dart. Building on top of community-maintained NoSQL solutions would be riskier for a multi-year roadmap.

## 3.2 Backend Strategy: Balancing V1 Speed with V2/V3 Needs

The backend must handle authentication, data synchronization, and note sharing.

### Analysis of Options

* **Firebase** – Comprehensive and integrates easily with Flutter, but relies on NoSQL databases (Firestore/Realtimedb) which are not ideal for the app's relational data. Pricing can become complex.
* **Supabase** – Built on PostgreSQL and open source. Provides authentication, storage, and real-time capabilities. Fits naturally with the relational schema of PicoNotes and avoids vendor lock‑in.
* **Custom Backend** – Maximum flexibility but requires significant development effort.

### Recommendation

Supabase is recommended as it combines relational data modeling with real-time features and predictable pricing. Its open-source nature allows for self-hosting and reduces lock-in.

Using Drift locally and Supabase remotely means the schemas can closely mirror each other, simplifying synchronization logic.

## 3.3 Data Synchronization Strategy

Repositories (e.g. `NoteRepository`, `FolderRepository`) will mediate between Drift and Supabase.

For V1 the app will use a "fetch-and-cache" approach:

1. When online, the latest data is fetched from Supabase and stored in Drift.
2. When offline, the app reads from the cached Drift database.
3. Any changes made while offline are queued locally and synchronized once network connectivity returns.

This lays the groundwork for the real-time collaboration features planned for later versions.

