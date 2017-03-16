== Emulating Oracle Database on H2 ==
<!--- pathing up populate.cfm --->
<cffile action="read" file="#ExpandPath('wheels/tests/populate.cfm')#" variable="content">
<!--- force "Oracle" as database product name --->
<cfset content=Replace(content,'loc.dbinfo.database_productname','"Oracle"',"all")>
<!--- skip missing to_timestamp() function --->
<cfset content=Replace(content,"to_timestamp(##loc.dateTimeDefault##,'yyyy-dd-mm hh24:mi:ss.FF')","'2000-01-01 18:26:08.690'","all")>
<!--- use default value instead of trigger for sequence --->
<cfset content=Replace(content,'CREATE TRIGGER bi_##loc.i## BEFORE INSERT ON ##loc.i## FOR EACH ROW BEGIN SELECT ##loc.seq##.nextval INTO :NEW.<cfif loc.i IS "photogalleries">photogalleryid<cfelseif loc.i IS "photogalleryphotos">photogalleryphotoid<cfelse>id</cfif> FROM dual; END;',
'ALTER TABLE ##loc.i## MODIFY COLUMN <cfif loc.i IS "photogalleries">photogalleryid<cfelseif loc.i IS "photogalleryphotos">photogalleryphotoid<cfelse>id</cfif> ##loc.identityColumnType## DEFAULT ##loc.seq##.nextval',"all")>
<cffile action="write" file="#ExpandPath('wheels/tests/populate.cfm')#" output="#content#">

<!--- pathing up Connection.cfc --->
<cffile action="read" file="#ExpandPath('wheels/Connection.cfc')#" variable="content">
<!--- force "Oracle" as adapter name --->
<cfset content=Replace(content,'loc.adapterName = "H2"','loc.adapterName = "Oracle"',"all")>
<cffile action="write" file="#ExpandPath('wheels/Connection.cfc')#" output="#content#">

<cfquery datasource="wheelstestdb">
	create or replace view all_tab_columns as
	select
		table_schema as owner,
		table_name,
		column_name,
		case type_name
			when 'STRING' then 'VARCHAR2'
			when 'VARCHAR' then 'VARCHAR2'
			when 'INTEGER' then 'NUMBER'
			when 'DOUBLE' then 'NUMBER'
			when 'DECIMAL' then 'NUMBER'
			else type_name
		end
		as data_type,
		is_nullable as nullable,
		numeric_precision as data_precision,
		character_maximum_length as data_length,
		numeric_scale as data_scale,
		column_default as data_default,
		ordinal_position as column_id
	from information_schema.columns
	where table_schema<>'INFORMATION_SCHEMA'
</cfquery>
<cfquery datasource="wheelstestdb">
	create or replace view all_constraints as
	select
		table_schema as owner,
		table_name,
		left(constraint_type,1) as constraint_type,
		constraint_name
	from information_schema.constraints
	where table_schema<>'INFORMATION_SCHEMA'
</cfquery>
<cfquery datasource="wheelstestdb">
	create or replace view all_cons_columns as
	select
		table_schema as owner,
		column_name,
		constraint_name
	from information_schema.indexes
	where table_schema<>'INFORMATION_SCHEMA'
</cfquery>
<cfquery datasource="wheelstestdb" name="result">
	select * from all_tab_columns
</cfquery>
<cfdump var="#result#">
