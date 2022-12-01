all: run

helloWorld.class: helloWorld.java
	javac helloWorld.java

hello_world: hello_world.c
	gcc -o hello_world -L/usr/lib/jvm/java-10-openjdk/lib/jli -L/usr/lib/jvm/java-10-openjdk/lib/server -I/usr/lib/jvm/java-10-openjdk/include/linux -I/usr/lib/jvm/java-10-openjdk/include/ -I/usr/lib/jvm/java-10-openjdk/include/darwin -L/usr/lib/jvm/java-10-openjdk/jre/lib/jli -L/usr/lib/jvm/java-10-openjdk/jre/lib/server/ -ljli -ljvm hello_world.c

run: helloWorld.class hello_world
	LD_LIBRARY_PATH=/usr/lib/jvm/java-10-openjdk/lib/jli:/usr/lib/jvm/java-10-openjdk/lib/server ./hello_world

clean:
	rm -f helloWorld.class hello_world
