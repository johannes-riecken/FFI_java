/*
These three pages were instrumental while trying to get this working.
I started with existing examples, got them working, and updated
them to make sure I understood how things worked. If you are trying this
for the first time, I suggest adding a new method with different arguments
to the Java class and then calling it from this C program.
Use 'javap -s -p helloWorld.class' to get the new method signature.
After that is working, package the class in a jar file, update the class
path in this C source file, and get that working.
http://www.inonit.com/cygwin/jni/invocationApi/c.html
http://www.codeproject.com/Articles/22881/How-to-Call-Java-Functions-from-C-Using-JNI
http://java.sun.com/developer/onlineTraining/Programming/JDCBook/jniexamp.html
*/

#include <stdio.h>
#include <jni.h>

JNIEnv* create_vm(JavaVM **jvm)
{
    JNIEnv* env;
    JavaVMInitArgs args;
    JavaVMOption options;
    args.version = JNI_VERSION_1_8;
    args.nOptions = 1;
    // options.optionString = "-Djava.class.path=./";
    options.optionString = "-Djava.class.path=./foo.jar";
    args.options = &options;
    args.ignoreUnrecognized = 0;
    int rv;
    rv = JNI_CreateJavaVM(jvm, (void**)&env, &args);
    if (rv < 0 || !env)
        printf("Unable to Launch JVM %d\n",rv);
    else
        printf("Launched JVM! :)\n");
    return env;
}

void invoke_class(JNIEnv* env)
{
    jclass hello_world_class;
    jmethodID main_method;
    jmethodID get_width_method;
    jint number=20;
    jint width=20;
    jint height=30;
    jint bpp=4;
    jint exponent=3;
    jbyte i = 'a';
    jobject img;
    hello_world_class = (*env)->FindClass(env, "com/tinyrenderer/demo/tgimage/TGAImage");
    if (hello_world_class == 0) {
      printf("class is null");
    }
    get_width_method = (*env)->GetMethodID(env, hello_world_class, "get_width", "()I");
    if (get_width_method == 0) {
      printf("method is null");
    }
    main_method = (*env)->GetMethodID(env, hello_world_class, "<init>", "(III)V");
    if (main_method == 0) {
      printf("method is null");
    }
    img = (*env)->NewObject(env, hello_world_class, main_method, width, height, bpp);
    int res = (*env)->CallIntMethod(env, img, get_width_method, NULL);
    printf("res: %d\n", res);
}

int main(int argc, char **argv)
{
    JavaVM *jvm;
    JNIEnv *env;
    env = create_vm(&jvm);
    if(env == NULL)
        return 1;
    invoke_class(env);
    return 0;
}
