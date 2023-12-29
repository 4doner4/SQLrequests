SELECT
	distinct (head.users.body -> '__name') as emplname,
	(head.users.body -> '__id') as ids,
	COUNT(
		(head."_system_catalogs:protocol".body -> '__name') :: jsonb ->> 0
	) as type_protocol
FROM
	head.tasks
	JOIN head.bp_instances ON (head.tasks.body -> 'instance' -> '__id') :: jsonb ->> 0 = head.bp_instances.id :: text
	JOIN head."_system_catalogs:protocol" ON head."_system_catalogs:protocol".id :: text = (
		head.bp_instances.body -> 'type_of_question_being_raised'
	) :: jsonb ->> 0
	JOIN head.users ON (head.tasks.body -> 'performers') :: json ->> 0 = head.users.id :: text
where
	(head.tasks.body -> 'state') :: jsonb ->> 0 = 'closed'
	AND CAST ((head.users.body -> 'groupIds') as varchar(255)) LIKE '%2c960f5c-8ecb-4a6d-b978-a8d1e0257740%'
	AND (head.tasks.body -> '__createdAt') :: jsonb ->> 0 >= '${Context.data.ot!.format(' yyyy - MM - DD ')}'
	AND (head.tasks.body -> '__createdAt') :: jsonb ->> 0 <= '${Context.data.do!.format(' yyyy - MM - DD ')}'
GROUP BY
(emplname, ids) 


-- ///////////////////////////////////////////////////////////////////////////////////////////////////////


SELECT
	o :: jsonb -> 'reconciling' ->> 0 AS emplName,
	o :: jsonb -> 'date_of_approval' ->> 0 as apprdate
from
	(
		select
			o -> 'sheet_approval' as rows
		from
			(
				select
					o
				from
					head."kipros:protocol_document"
					cross join jsonb_array_elements(body -> 'archive_of_the_approval_sheet' -> 'rows') as c(o)
				where
					(
						head."kipros:protocol_document".body -> '__createdAt'
					) :: jsonb ->> 0 >= '${Context.data.ot!.format(' yyyy - MM - DD ')}'
					and (
						head."kipros:protocol_document".body -> '__createdAt'
					) :: jsonb ->> 0 <= '${Context.data.do!.format(' yyyy - MM - DD ')}'
			) as rows
	) AS ROWS
	CROSS JOIN jsonb_array_elements(ROWS -> 'rows') AS c(o)
WHERE
	(o :: jsonb -> 'date_of_approval' ->> 0) :: text IS NOT NULL
	AND (o :: jsonb -> 'reconciling' ->> 0) :: text IS NOT NULL 
	
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////


SELECT
	(head."kipros:profile_dzo".body -> '__name') :: jsonb as ProfilDzo,
	(
		head."kipros:protocol_document".body -> 'archive_of_the_approval_sheet' -> 'rows'
	) :: jsonb as ProtDoc
FROM
	head.tasks
	JOIN head.bp_instances ON (head.tasks.body -> 'instance' -> '__id') :: jsonb ->> 0 = head.bp_instances.id :: text
	JOIN head."kipros:profile_dzo" ON (head.bp_instances.body -> 'pasport_pk') :: json ->> 0 = head."kipros:profile_dzo".id :: text
	join head."kipros:protocol_document" on head."kipros:protocol_document".id :: text = (head.bp_instances.body -> 'protokol_document') :: jsonb ->> 0
	JOIN head.users ON (head.tasks.body -> 'performers') :: json ->> 0 = head.users.id :: text 
	
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////


SELECT
	ids :: jsonb ->> 0 as id,
	ProfilDzo :: jsonb ->> 0 as dzo,
	(o1 -> 'solution') :: jsonb ->> 0 AS solution,
	(o1 -> 'stageName') :: jsonb ->> 0 as stageName,
	(o1 -> 'date_of_approval') :: jsonb ->> 0 as date_of_approval
FROM
	(
		SELECT
			o -> 'sheet_approval' as columnsArchive,
			ProfilDzo,
			ids
		FROM
			(
				select
					(head."kipros:protocol_document".body -> '__id') :: jsonb as ids,
					(head."kipros:profile_dzo".body -> '__name') :: jsonb as ProfilDzo,
					(head."kipros:protocol_document".body) :: jsonb as ProtDoc
				from
					head.tasks
					JOIN head.bp_instances ON (head.tasks.body -> 'instance' -> '__id') :: jsonb ->> 0 = head.bp_instances.id :: text
					JOIN head."kipros:profile_dzo" ON (head.bp_instances.body -> 'pasport_pk') :: json ->> 0 = head."kipros:profile_dzo".id :: text
					join head."kipros:protocol_document" on head."kipros:protocol_document".id :: text = (head.bp_instances.body -> 'protokol_document') :: jsonb ->> 0
			) as rows
			cross join jsonb_array_elements(protdoc -> 'archive_of_the_approval_sheet' -> 'rows') as c(o)
	) as Rows
	CROSS JOIN jsonb_array_elements(columnsArchive -> 'rows') AS c(o1)
WHERE
	(o1 :: jsonb -> 'date_of_approval' ->> 0) :: text IS NOT NULL
	AND (o1 -> 'stageName') :: jsonb ->> 0 IS NOT NULL 
	
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////


select
	*
from
	(
		select
			jsonb :: jsonb as jsonb
		from
			(
				select
					(jsonb -> 'sheet_approval' ->> 'rows') :: jsonb as jsonb
				from
					(
						select
							jsonb :: jsonb -> 0 as jsonb
						from
							(
								select
(
										(
											head."kipros:protocol_document".body -> 'archive_of_the_approval_sheet' ->> 'rows'
										) :: JSONB
									)
								from
									head."kipros:protocol_document"
								LIMIT
									100
							) as rows
					) as sheet
			) as rows
	) elen
where
	jsonb :: jsonb is not null 
	
-- ////////////////////////////////////////////////////////////////


SELECT
	(
		head."kipros:protocol_document".body -> 'archive_of_the_approval_sheet'
	) :: jsonb as archive
FROM
	head."kipros:protocol_document"
where
	(
		head."kipros:protocol_document".body -> 'archive_of_the_approval_sheet'
	) :: jsonb is not null
	AND (
		head."kipros:protocol_document".body -> '__createdAt'
	) :: jsonb ->> 0 >= '${Context.data.ot!.format(' yyyy - MM - DD ')}'
	AND (
		head."kipros:protocol_document".body -> '__createdAt'
	) :: jsonb ->> 0 <= '${Context.data.do!.format(' yyyy - MM - DD ')}';

-- ////////////////////////////////////////////////////////////////
-- ЗАпрос документов прокотолов 
select
	o
from
	(
		select
			(jsonb -> 'sheet_approval') :: jsonb as jsonb
		from
			(
				select
					jsonb :: jsonb -> 0 as jsonb
				from
					(
						select
(
								(
									head."kipros:protocol_document".body -> 'archive_of_the_approval_sheet' ->> 'rows'
								) :: JSONB
							)
						from
							head."kipros:protocol_document"
						where
							(
								head."kipros:protocol_document".body -> '__createdAt'
							) :: jsonb ->> 0 >= '2021-05-27T12:18:56Z'
							AND (
								head."kipros:protocol_document".body -> '__createdAt'
							) :: jsonb ->> 0 <= '2022-05-27T12:18:56Z'
					) as rows
			) as sheet
	) as rows
	cross join jsonb_array_elements(rows.jsonb -> 'rows') as c(o)
where
	(o :: jsonb -> 'stageName') :: text like '%Эксперт ДУА%' 
	
-- /////////////////////////////////////////////////////////////


select
	head."kipros:protocol_document".id as ids,
	Sum(jsonb_array_length(o -> 'sheet_approval' -> 'rows'))
from
	head."kipros:protocol_document"
	cross join jsonb_array_elements(body -> 'archive_of_the_approval_sheet' -> 'rows') as c(o)
GROUP BY
(ids) 

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////


SELECT
	ProfilDzo :: jsonb ->> 0 as dzo,
	(o1 -> 'solution') :: jsonb ->> 0 AS solution,
	(o1 -> 'stageName') :: jsonb ->> 0 as stageName,
	(o1 -> 'date_of_approval') :: jsonb ->> 0 as date_of_approval
FROM
	(
		SELECT
			o -> 'sheet_approval' as columnsArchive,
			ProfilDzo
		FROM
			(
				select
					(head."kipros:profile_dzo".body -> '__name') :: jsonb as ProfilDzo,
					(head."kipros:protocol_document".body) :: jsonb as ProtDoc
				from
					head.tasks
					JOIN head.bp_instances ON (head.tasks.body -> 'instance' -> '__id') :: jsonb ->> 0 = head.bp_instances.id :: text
					JOIN head."kipros:profile_dzo" ON (head.bp_instances.body -> 'pasport_pk') :: json ->> 0 = head."kipros:profile_dzo".id :: text
					join head."kipros:protocol_document" on head."kipros:protocol_document".id :: text = (head.bp_instances.body -> 'protokol_document') :: jsonb ->> 0
				where
					(
						head."kipros:protocol_document".body -> '__createdAt'
					) :: jsonb ->> 0 >= '${Context.data.ot!.format(' yyyy - MM - DD ')}'
					and (
						head."kipros:protocol_document".body -> '__createdAt'
					) :: jsonb ->> 0 <= '${Context.data.do!.format(' yyyy - MM - DD ')}'
			) as rows
			cross join jsonb_array_elements(protdoc -> 'archive_of_the_approval_sheet' -> 'rows') as c(o)
	) as Rows
	CROSS JOIN jsonb_array_elements(columnsArchive -> 'rows') AS c(o1)
WHERE
	(o1 :: jsonb -> 'date_of_approval' ->> 0) :: text IS NOT NULL
	AND (o1 -> 'stageName') :: jsonb ->> 0 IS NOT NULL
	AND (ProfilDzo) :: jsonb ->> 0 LIKE '${Context.data.dzolist!}' 
	
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////


select
	distinct (head."kipros:profile_dzo".body -> '__name') :: jsonb ->> 0 as dzo
from
	head.bp_instances
	JOIN head."kipros:profile_dzo" ON (head.bp_instances.body -> 'pasport_pk') :: json ->> 0 = head."kipros:profile_dzo".id :: text
	join head."kipros:protocol_document" on head."kipros:protocol_document".id :: text = (head.bp_instances.body -> 'protokol_document') :: jsonb ->> 0
WHERE
	(
		head."kipros:protocol_document".body -> '__createdAt'
	) :: jsonb ->> 0 >= '${Context.data.ot!.format(' yyyy - MM - DD ')}'
	AND (
		head."kipros:protocol_document".body -> '__createdAt'
	) :: jsonb ->> 0 <= '${Context.data.do!.format(' yyyy - MM - DD ')}'