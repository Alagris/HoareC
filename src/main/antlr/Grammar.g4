grammar Grammar;

start
:
	procedures
;

procedures
:
	procedure procedures # ProceduresMore
	| # ProceduresLast
;

ids
:
	ID ids # IDMore
	| # IDLast
;

procedure
:
	'procedure' ID 'requires' equivalence 'ensures' equivalence 'vars' ids 'ghost'
	ids 'steps' statements 'end'
;

statements
:
	statement statements # StatementsMore
	| statement # StatementsLast
;

statement
:
	'skip' # StatementSkip
	| 'if' equivalence 'then' statements 'else' statements 'fi' # StatementIf
	| ID ':=' arithemtic_expr # StatementAssign
	| '{' equivalence '}' # StatementClause
	| 'while' equivalence 'invariant' equivalence 'variant' arithemtic_expr 'do' statements 'done' #
	StatementWhile
	| 'echo' StringLiteral arithemtic_expr # StatementEcho
;

equivalence
:
	implication '<=>' implication  # EquivalenceMore
	| implication # EquivalenceLast
;

implication
:
	disjunction '=>' implication # ImplicationMore
	| disjunction # ImplicationLast
;

disjunction
:
	conjunction '\\/' disjunction # DisjunctionMore
	| conjunction # DisjunctionLast
;

conjunction
:
	negation '/\\' conjunction # ConjunctionMore
	| negation # ConjunctionLast
;

negation
:
	'~' atom # NegationFalse
	| atom # NegationTrue
;

atom
:
	inequality # AtomArithm
	| '(' equivalence ')' # AtomLogic
	| 'true' # AtomTrue
	| 'false' # AtomFalse
;

inequality
:
	arithemtic_expr '<' arithemtic_expr # IneqLt
	| arithemtic_expr '>' arithemtic_expr # IneqGt
	| arithemtic_expr '<=' arithemtic_expr # IneqLe
	| arithemtic_expr '>=' arithemtic_expr # IneqGe
	| arithemtic_expr '=' arithemtic_expr # IneqEq
	| arithemtic_expr '<>' arithemtic_expr # IneqNeq
;

arithemtic_expr
:
	arithemtic_expr '+' arithemtic_expr_mult  # AirthmPlus
	| arithemtic_expr '-' arithemtic_expr_mult  # AirthmMinus
	| arithemtic_expr_mult # AirthmLast
;

arithemtic_expr_mult
:
	arithemtic_expr_mult '*' arithemtic_term # MultProduct
	| arithemtic_expr_mult '/' arithemtic_term  # MultInverse
	| arithemtic_term # MultLast
;

arithemtic_term
:
	'-' arithemtic_atomic_expr # ArithmNeg
	| arithemtic_atomic_expr # ArithmNoNeg
;

arithemtic_atomic_expr
:
	ID # ArithmVar
	| INT # ArithmLiteral
	| '(' arithemtic_expr ')' # ArithmNested
;

StringLiteral
:
	UnterminatedStringLiteral '"'
;

UnterminatedStringLiteral
:
	'"'
	(
		~["\\\r\n]
		| '\\'
		(
			.
			| EOF
		)
	)*
;

INT
:
	[0-9]+
;

ID
:
	[a-zA-Z_] [a-zA-Z_0-9]*
;

WS
:
	(
		' '
		| '\t'
		| '\n'
	)+ -> channel ( HIDDEN )
;
/*
 * 
 * w : x y
 * f(x:x y) x y 
 */