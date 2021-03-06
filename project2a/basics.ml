(****************************)
(* Part 1: Simple Functions *)
(****************************)

let mult_of_y x y =
	if y <> 0 then 
		(if (x mod y) == 0 then true 
		else false)
	else false
;; 

let head_divisor lst = 
	match lst with
	| [] -> false
	| h::[] -> false
	| h::s::t -> if (h mod s) == 0 then true else false
;;

let second_element lst =
	match lst with
	| [] -> -1
	| h::[] -> -1
	| h::s::t -> s
;;

let sum_first_three lst = 
	match lst with
	| [] -> 0
	| h::[] -> h
	| h::x::[] -> (h + x)
	| h::x::y::t -> (h + x + y) 
;;

(************************************)
(* Part 2: Recursive List Functions *)
(************************************)


let rec get_val i lst = 
	match lst with
	| [] -> -1
	| h::t -> if i=0 then h else get_val (i-1) t 
;;

let rec get_vals is lst = 
	match is with
	| [] -> []
	| h::t -> get_val h lst::(get_vals t lst)  
;;

let rec list_swap_val lst x y =
	match lst with
	| [] -> []
	| h::t -> (if h=x then y
		else if h=y then x
		else h)::(list_swap_val t x y)
;;

(* THE NEXT THREE FUNCTIONS ARE FOR UNZIP *)

let rec append_end x lst =
	match lst with
	| [] -> x::[]
	| h::t -> h::(append_end x t)
;;
	
let rec unzip_aux lst lst1 lst2 =
	match lst with
	| [] -> (lst1, lst2)
	| (x,y)::t -> unzip_aux t (append_end x lst1) (append_end y lst2)
;;

let rec unzip lst =
	match lst with
	| [] -> ([],[])
	| h::t -> unzip_aux lst [] []
;;

(* THE END OF UNZIP *)

let rec index_help x lst curr = 
	match lst with
	| [] -> -1
	| h::t -> if h=x then curr 
		else (index_help x t (curr + 1)) 
;;	

let rec index x lst = 
	match lst with
	| [] -> -1
	| h::t -> index_help x lst 0
;;

(****************)
(* Part 3: Sets *)
(****************)

let rec elem x a =
	match a with
	| [] -> false
	| h::t -> if h=x then true else elem x t
;;

let rec insert x a = 
	if (elem x a)=false then x::a
	else a 
;;

let rec card_help a count =
	match a with
	| [] -> count
	| h::t -> card_help t (count + 1)
;; 

let rec card a =
	card_help a 0 
;;

let rec remove x a = 
	match a with
	| [] -> a
	| h::t -> if h <> x then h::(remove x t) else (remove x t)
;;

let rec union a b = 
	match a with
	| [] -> b
	| h::t -> union t (insert h b)
;; 

let rec intersection a b = 
	match a with
	| [] -> a
	| h::t -> if (elem h b)=false then (intersection t b)
	else h::(intersection t b)
;;

let rec subset_help a b status =
	match a with
	| [] -> status
	| h::t -> if (elem h b)=false then false
	else (subset_help t b true)
;;  

let rec subset a b = 
	match a with
	| [] -> true
	| h::t -> subset_help a b true
;;

let rec eq a b =
	match a with
	| [] -> (subset b a)
	| h::t -> (subset a b) && (subset b a)
;;

