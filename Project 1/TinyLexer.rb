# https://www.cs.rochester.edu/~brown/173/readings/05_grammars.txt
#
#  "TINY" Grammar with Boolean
# PGM		 -->   STMTSEQ
# STMTSEQ    -->   STMT+
# STMT       -->   ASSIGN   |   "print"  EXP   | IFSTMT | LOOPSTMT                        
# IFSTMT	 -->   if COMPARISON then STMTSEQ
# LOOPSTMT	 -->   while COMPARISON then STMTSEQ
# COMPARISON -->   FACTOR ( "<" | ">" | "&" ) FACTOR
# ASSIGN     -->   ID  "="  EXP
# EXP        -->   TERM   ETAIL
# ETAIL      -->   "+" TERM   ETAIL  | "-" TERM   ETAIL | EPSILON
# TERM       -->   FACTOR  TTAIL
# TTAIL      -->   "*" FACTOR TTAIL  | "/" FACTOR TTAIL | EPSILON
# FACTOR     -->   "(" EXP ")" | INT | ID   
#                  
# ID         -->   ALPHA+
# ALPHA      -->   a  |  b  | … | z  or 
#                  A  |  B  | … | Z
# INT        -->   DIGIT+
# DIGIT      -->   0  |  1  | …  |  9
# WHITESPACE -->   Ruby Whitespace

#
#  Class Lexer - Reads a TINY program and emits tokens
#
class Lexer
# Constructor - Is passed a file to scan and outputs a token
#               each time nextToken() is invoked.
#   @c        - A one character lookahead 
	def initialize(filename)
		# Need to modify this code so that the program
		# doesn't abend if it can't open the file but rather
		# displays an informative message
		begin		
			@f = File.open(filename,'r:utf-8')
		rescue
			puts "Sorry, I could not find your file!"
		end

		# Go ahead and read in the first character in the source
		# code file (if there is one) so that you can begin
		# lexing the source code file 
		if (! @f.eof?)
			@c = @f.getc()
		else
			@c = "eof"
			@f.close()
		end
	end
	
	# Method nextCh() returns the next character in the file
	def nextCh()
		if (! @f.eof?)
			@c = @f.getc()
		else
			@c = "eof"
		end
		
		return @c
	end

	# Method nextToken() reads characters in the file and returns
	# the next token
	def nextToken() 
		if @c == "eof"
			tok = Token.new(Token::EOF,"eof")
				
		elsif (whitespace?(@c))
			str = ""
		
			while whitespace?(@c)
				str += @c
				nextCh()
			end
		
			tok = Token.new(Token::WS,str)

		elsif (letter?(@c))
			str = ""
			
			while letter?(@c)
				str += @c
				nextCh()
			end

			if str == "print"
				tok = Token.new(Token::PRINT,str)

			elsif str == "epsilon"
				tok = Token.new(Token::EPSILON,str)

			elsif str == "if" || str == "while" || str == "end" || str == "then"
				tok = Token.new(Token::COMPARISON,str)
				
			else
				tok = Token.new(Token::ABC, str)
			end


		elsif (numeric?(@c))
			str = ""
			
			while numeric?(@c)
				str += @c
				nextCh()
			end

			tok = Token.new(Token::NUM,str)

		elsif @c == "("
			tok = Token.new(Token::LPAREN, "(")
			nextCh()

		elsif @c == ")"
			tok = Token.new(Token::RPAREN, ")")
			nextCh()

		elsif @c == "!" || @c == ";" || @c == ">" || @c == "<" || @c == "&"
			tok = Token.new(Token::SYMBOL,@c)
			nextCh()

		elsif @c == "+" || @c == "-" || @c == "*" || @c == "/" || @c == "="
			tok = Token.new(Token::OPS,@c)
			nextCh()

		else
			tok = Token.new(UNKNWN,@c)
		end
	
		puts "Next token is: #{tok.type} Next lexeme is: #{tok.text}"
		return tok
	end
end
#
# Helper methods for Scanner
#
def letter?(lookAhead)
	lookAhead =~ /^[a-z]|[A-Z]$/
end

def numeric?(lookAhead)
	lookAhead =~ /^(\d)+$/
end

def whitespace?(lookAhead)
	lookAhead =~ /^(\s)+$/
end