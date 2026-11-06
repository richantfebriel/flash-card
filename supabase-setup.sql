-- Jalankan sekali di Supabase: SQL Editor → New query → tempel → Run
create table if not exists public.cards (
  id        text primary key,
  user_id   uuid not null default auth.uid() references auth.users(id) on delete cascade,
  word      text not null default '',
  meaning   text not null default '',
  example   text not null default '',
  box       int  not null default 1,
  due       bigint not null default 0,
  n_right   int  not null default 0,
  n_wrong   int  not null default 0,
  created   bigint not null default 0,
  updated   bigint not null default 0,
  deleted   boolean not null default false
);
create index if not exists cards_user_idx on public.cards(user_id);

alter table public.cards enable row level security;

-- izin untuk user yang login (perlu kalau "Automatically expose new tables" dimatikan)
grant select, insert, update, delete on public.cards to authenticated;

drop policy if exists "own cards select" on public.cards;
drop policy if exists "own cards insert" on public.cards;
drop policy if exists "own cards update" on public.cards;
drop policy if exists "own cards delete" on public.cards;
create policy "own cards select" on public.cards for select using (auth.uid() = user_id);
create policy "own cards insert" on public.cards for insert with check (auth.uid() = user_id);
create policy "own cards update" on public.cards for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "own cards delete" on public.cards for delete using (auth.uid() = user_id);
