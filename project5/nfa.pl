:- module(nfa,[
       move/4,
       productive/2,
       e_closure/3,
       accept/2,
       enumerate/3
   ]).

% Predicate: state(M,I)
% Description: I is a state of M.
% Usage: If M is an NFA, then state(M,I) succeeds with all solutions for I.

state(nfa(States,_,_,_,_),I) :-
    member(I,States).

% Predicate: sigma(M,A)
% Description: A is a member of the alphabet of M.
% Usage: If M is an NFA, then sigma(M,A) succeeds with all solutions for A.

sigma(nfa(_,Sigma,_,_,_),A) :-
    member(A,Sigma).

% Predicate: delta(M,T)
% Description: T is a transition in M.
% Notes: A transition is a triple (I,A,J) where I and J are states and A is a symbol.
% Usage: If M is an NFA, then delta(M,T) succeeds with all solutions for T.

delta(nfa(_,_,Delta,_,_),I,A,J) :-
    member((I,A,J),Delta).

% Predicate: start(M,I)
% Description: I is the start state of I.
% Usage: If M is an NFA, then start(M,I) succeeds with one solution for M.

start(nfa(_,_,_,Start,_),Start).

% Predicate: final(M,I)
% Description: I is a final state of M.
% Usage: If M is an NFA, then final(M,F) succeeds with all solutions for I.

final(nfa(_,_,_,_,Finals),I) :-
    member(I,Finals).

% Predicate: move(M,From,A,To)
% Description: M can transition to state To from state From on symbol A.
% Usage: If M is an NFA, then move(M,From,A,To) succeeds with all solutions for From, A and To.

move(M,From,A,To) :-
	delta(M,From,A,To),
	A \== epsilon.

% Predicate: e_closure(M,From,To)
% Description: To is an element of the epsilon-closure of From.
% Usage: If M is an NFA, then e_closure(M,From,To) succeeds with all solutions for From and To.

e_closure(M,From,From,_) :- 
	state(M,From).

e_closure(M,From,To,VS) :-
	\+ member(From,VS),
	delta(M,From,epsilon,T),
	e_closure(M,T,To,[From|VS]).	

e_closure(M,From,To) :-
	e_closure(M,From,To,[]).

% Predicate: accept(M,String)
% Description: String is accepted by M.
% Usage: If M is an NFA and String a string, then accept(M,String) succeeds if M accepts String.

accept(M,[],CurrNode) :-
	final(M,CurrNode).

accept(M,[H|T],CurrNode) :-
	move(M,CurrNode,H,Next),
	e_closure(M,Next,N2),	
	accept(M,T,N2).

accept(M,String) :-
	start(M,Start),
	e_closure(M,Start,X),
	accept(M,String,X).

% Predicate: productive(M,State)
% Description: There is a final state reachable from State in M.
% Usage: If M is an NFA, then productive(M,State) succeeds with all solutions for State.

productive(M,State,VS) :-
	\+ member(State,VS),
	final(M,State).

productive(M,State,VS) :-
	\+ member(State,VS),
	move(M,State,A,X),
	A \== epsilon,
	productive(M,X,[State|VS]).
	

productive(M,State,VS) :-
	\+ member(State,VS),
	e_closure(M,State,S2),
	productive(M,S2,[State|VS]).

productive(M,State) :-
	productive(M,State,[]).

% Predicate: enumerate(M,Len,String)
% Description: String is a string of length Len accepted by the NFA.
% Usage: If M is an NFA, then enumerate(M,Len,String) succeeds with all solutions for Len and String.

enumerate(M,Len,String) :-
	length(String,Len),
	accept(M,String).

