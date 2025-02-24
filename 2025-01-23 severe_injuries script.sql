-- Column: public.severe_injuries."Employer"

-- ALTER TABLE IF EXISTS public.severe_injuries DROP COLUMN IF EXISTS "Employer";

ALTER TABLE public.severe_injuries
    ALTER COLUMN "Employer" 
	TYPE character;

-- View table
SELECT *
FROM public.severe_injuries;