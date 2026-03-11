-- Migration: Create agent_memory table for Solengo Trade AI agent
-- Run this in Supabase SQL editor

CREATE TABLE IF NOT EXISTS agent_memory (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  symbol TEXT NOT NULL,
  signal TEXT NOT NULL, -- BUY, SELL, WAIT
  confidence INTEGER,
  direction TEXT, -- LONG, SHORT
  sources_used TEXT[], -- array of source names
  entry_price NUMERIC(12,4),
  exit_price NUMERIC(12,4),
  pnl_pct NUMERIC(8,4),
  outcome TEXT DEFAULT 'OPEN', -- OPEN, WAIT, WIN, LOSS
  news_titles TEXT[], -- array of news titles at time of signal
  geo_alert BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  closed_at TIMESTAMPTZ
);

-- Index for fast lookups
CREATE INDEX IF NOT EXISTS idx_agent_memory_symbol ON agent_memory(symbol);
CREATE INDEX IF NOT EXISTS idx_agent_memory_outcome ON agent_memory(outcome);
CREATE INDEX IF NOT EXISTS idx_agent_memory_created ON agent_memory(created_at DESC);

-- Enable RLS
ALTER TABLE agent_memory ENABLE ROW LEVEL SECURITY;

-- Allow all operations for authenticated users (paper trading app, single user)
CREATE POLICY "Allow all for anon" ON agent_memory FOR ALL TO anon USING (true) WITH CHECK (true);

-- Grant access
GRANT ALL ON agent_memory TO anon;
GRANT ALL ON agent_memory TO authenticated;
