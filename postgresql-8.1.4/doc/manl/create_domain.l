.\\" auto-generated by docbook2man-spec $Revision: 1.1.1.1 $
.TH "CREATE DOMAIN" "" "2005-11-05" "SQL - Language Statements" "SQL Commands"
.SH NAME
CREATE DOMAIN \- define a new domain

.SH SYNOPSIS
.sp
.nf
CREATE DOMAIN \fIname\fR [AS] \fIdata_type\fR
    [ DEFAULT \fIexpression\fR ]
    [ \fIconstraint\fR [ ... ] ]

where \fIconstraint\fR is:

[ CONSTRAINT \fIconstraint_name\fR ]
{ NOT NULL | NULL | CHECK (\fIexpression\fR) }
.sp
.fi
.SH "DESCRIPTION"
.PP
\fBCREATE DOMAIN\fR creates a new data domain. The
user who defines a domain becomes its owner.
.PP
If a schema name is given (for example, CREATE DOMAIN
myschema.mydomain ...) then the domain is created in the
specified schema. Otherwise it is created in the current schema.
The domain name must be unique among the types and domains existing
in its schema.
.PP
Domains are useful for abstracting common fields between tables
into a single location for maintenance. For example, an email address
column may be used in several tables, all with the same properties.
Define a domain and use that rather than setting up each table's
constraints individually. 
.sp
.RS
.B "Caution:"
At present, declaring a function result value as a domain 
is pretty dangerous, because none of the procedural languages enforce domain constraints 
on their results. You'll need to make sure that the function code itself
respects the constraints. In \fBPL/pgSQL\fR, one possible
workaround is to explicitly cast the result value to the domain type
when you return it. \fBPL/pgSQL\fR does not enforce domain
constraints for local variables within functions, either.
.RE
.sp
.SH "PARAMETERS"
.TP
\fB\fIname\fB\fR
The name (optionally schema-qualified) of a domain to be created.
.TP
\fB\fIdata_type\fB\fR
The underlying data type of the domain. This may include array
specifiers.
.TP
\fBDEFAULT \fIexpression\fB\fR
The DEFAULT clause specifies a default value for
columns of the domain data type. The value is any
variable-free expression (but subqueries are not allowed).
The data type of the default expression must match the data
type of the domain. If no default value is specified, then
the default value is the null value.

The default expression will be used in any insert operation
that does not specify a value for the column. If a default
value is defined for a particular column, it overrides any
default associated with the domain. In turn, the domain
default overrides any default value associated with the
underlying data type.
.TP
\fBCONSTRAINT \fIconstraint_name\fB\fR
An optional name for a constraint. If not specified,
the system generates a name.
.TP
\fBNOT NULL\fR
Values of this domain are not allowed to be null.
.TP
\fBNULL\fR
Values of this domain are allowed to be null. This is the default.

This clause is only intended for compatibility with
nonstandard SQL databases. Its use is discouraged in new
applications.
.TP
\fBCHECK (\fIexpression\fB)\fR
CHECK clauses specify integrity constraints or tests
which values of the domain must satisfy.
Each constraint must be an expression
producing a Boolean result. It should use the name VALUE
to refer to the value being tested.

Currently, CHECK expressions cannot contain
subqueries nor refer to variables other than VALUE.
.SH "EXAMPLES"
.PP
This example creates the \fBus_postal_code\fR data type and
then uses the type in a table definition. A regular expression test
is used to verify that the value looks like a valid US postal code.
.sp
.nf
CREATE DOMAIN us_postal_code AS TEXT
CHECK(
   VALUE ~ '^\\\\d{5}$'
OR VALUE ~ '^\\\\d{5}-\\\\d{4}$'
);

CREATE TABLE us_snail_addy (
  address_id SERIAL NOT NULL PRIMARY KEY
, street1 TEXT NOT NULL
, street2 TEXT
, street3 TEXT
, city TEXT NOT NULL
, postal us_postal_code NOT NULL
);
.sp
.fi
.SH "COMPATIBILITY"
.PP
The command \fBCREATE DOMAIN\fR conforms to the SQL
standard.
.SH "SEE ALSO"
ALTER DOMAIN [\fBalter_domain\fR(l)], DROP DOMAIN [\fBdrop_domain\fR(l)]