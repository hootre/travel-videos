-- 여행 영상함 서버 설정 (Supabase SQL Editor에 붙여넣고 Run)
-- 1) 표 만들기
create table if not exists public.videos (
  id         text primary key,
  title      text not null default '',
  place      text not null default '',
  memo       text not null default '',
  trip_date  text not null default '',
  added      text not null default '',
  hidden     boolean not null default false,
  q          text,
  a_hash     jsonb,
  hint       text,
  updated_at timestamptz not null default now()
);

-- 2) 접근 권한 (RLS)
alter table public.videos enable row level security;

drop policy if exists "누구나 공개 영상 보기" on public.videos;
create policy "누구나 공개 영상 보기" on public.videos
  for select to anon
  using (hidden = false);          -- 숨긴 영상은 서버가 아예 안 내려줌

drop policy if exists "관리자 전체 권한" on public.videos;
create policy "관리자 전체 권한" on public.videos
  for all to authenticated
  using (true) with check (true);

-- 3) 기존 영상 13편 옮기기
insert into public.videos (id, title, place, memo, trip_date, added) values
  ('kQalLvMq7Mo', '터키 브랜드데이', '튀르키예', '정상남', '', '2026-09-03'),
  ('j5onwF0aLHo', '오사카 8인의 하프마라톤여행기', '오사카', '오사카 하프마라톤', '', '2026-09-03'),
  ('5dU8iLRfsVQ', '남정대장 튀르키예', '튀르키예', '정상남 릴스용', '', '2026-09-03'),
  ('EAkKFpvfCeU', '남정상 탄조비 오메대또', '천호', '남정상생일 축하해', '', '2026-09-03'),
  ('XvcFfDm-3tE', '딸배 3명의 도쿄 여행기', '도쿄', '그녀석 등장', '', '2026-09-03'),
  ('mR6ItQkHvaI', '식객(食客) 남정상', '오사카', '남정상과 오사카 데이트', '', '2026-09-03'),
  ('ckBurmBs1ng', '을왕리 대만팸', '을왕리', '잼민이 3놈 전역기념?', '', '2026-09-03'),
  ('cAhT09vGHLw', '대만 1일차', '대만', '대만 1일차 잼민이들', '', '2026-09-03'),
  ('QMitDKzmL_Y', '술찌우', '대만', '대만 2일차 아쓰다', '', '2026-09-03'),
  ('ku-_UZ60WQ8', '대만 3일차', '대만', '대만 3일차', '', '2026-09-03'),
  ('RcJ-0iH1U8g', '대만 4일차', '대만', '대만은 뭔데 일차별로 만들었노', '', '2026-09-03'),
  ('9lKAXZ_dCg0', '비발디 허리부셔 남정상', '비발디파크', '편집이 좀 시끄러움 ㅈㅅ', '', '2026-09-03'),
  ('H1McVjyj3JM', '데낄라 먹고싶다', '무이네', '호치민은 간적이없어요 그쵸', '', '2026-09-03')
on conflict (id) do nothing;
