BISON	= bison -d
FLEX	= flex
CC		= gcc
CXX		= g++
FLAGS   = # add the -g flag to compile with debugging output for gdb
TARGET	= lang

OBJS = parser.o lexer.o main.o

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CXX) -o $(TARGET) $(OBJS)

lexer.o: lexer.l
	$(FLEX) -o lexer.cpp lexer.l
	$(CXX) $(FLAGS) -c -o lexer.o lexer.cpp

parser.o: parser.y
	$(BISON) -o parser.cpp parser.y
	$(CXX) $(FLAGS) -c -o parser.o parser.cpp

main.o: main.cpp
	$(CXX) $(FLAGS) -c -o main.o main.cpp

.PHONY: run
run: $(TARGET)
	@python3 runtests.py

.PHONY: diff
diff: $(TARGET)
	python3 runtests.py -v | diff - output.txt

.PHONY: clean
clean:
	rm -f *.o *~ lexer.cpp parser.cpp parser.hpp parser.output $(TARGET)
