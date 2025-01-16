.PHONY: test database

test:
	gcc lib_src/test.c lib_src/database.c -o build/test.exe -static -ggdb3
	./build/test.exe

database:
	gcc -c lib_src/database.c -o build/database.o -ggdb
	ar cr database/database.a build/database.o
	rm -f src/libdatabase.a
	mv database/database.a src/libdatabase.a
