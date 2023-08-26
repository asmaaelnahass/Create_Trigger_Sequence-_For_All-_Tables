# Create_Trigger_Sequence-_For_All-_Tables

create  trigger sequence pairs on all tables in the schema
	- using loop  
 
	- drop all sequences first in the loop
 
	- replace any triggers if found 
 
	- set sequences to start with max id + 1
		for each table
	   ignore increment by [ only increment by 1 ]
 
	- donot forget to choose the PK column for each table


### Tools
- Database fundamentals / SQL
  
- SQL functions ( Aggregate / Date / Character / Number / Conversion )
  
- Other schema objects ( Views / Synonyms / Indexes / Sequences / Types / Roles /Data Dictionary)
  
- PL SQL fundamentals ( Variables / Conditions / Loops / Records / Cursors / Exceptions )
  
- PL SQL advanced ( Anonymous / Functions / Procedures / Packages / Dynamic SQL / Schedule Jobs )

