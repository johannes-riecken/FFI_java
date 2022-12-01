import core.stdc.stdio;
import core.stdc.stdlib;
import core.stdc.string;
import std.conv;
import jni;
import std.string;

JNIEnv* create_vm(JavaVM **jvm)
{
    JNIEnv* env;
    JavaVMOption options = {optionString: cast(char*)"-Djava.class.path=./foo.jar"};
    JavaVMInitArgs args = {_version: 0x00010008, nOptions: 1, options: &options, ignoreUnrecognized: 0};
    int rv = JNI_CreateJavaVM(jvm, cast(void**)&env, &args);

    // char *buf = cast(char*)calloc(50, char.sizeof);
    // strcat(buf, cast(const(char)*)"Unable to launch JVM");
    // strcat(buf, cast(const(char)*)to!string(rv));
    // assert(rv >= 0 && env, fromStringz(buf));
    // free(buf);

    return env;
}

void invoke_class(JNIEnv* env)
{
    jint number=20;
    jint width=20;
    jint height=30;
    jint bpp=4;
    jint exponent=3;
    jbyte i = 'a';
    jclass TGAImage = env.FindClass("com/tinyrenderer/demo/tgimage/TGAImage".ptr);
    assert(TGAImage !is null, "TGAImage is null");
    jmethodID getWidth = env.GetMethodID(TGAImage, "get_width".ptr, "()I".ptr);
    assert(getWidth !is null, "method is null");
    jmethodID main_method = env.GetMethodID(TGAImage, "<init>".ptr, "(III)V".ptr);
    assert(main_method !is null, "method is null");
    jobject img = env.NewObject(TGAImage, main_method, width, height, bpp);
    int res = env.CallIntMethod(img, getWidth, null);
    printf("res: %d\n", res);

    jclass Double = env.FindClass("java/lang/Double".ptr);
    assert(Double !is null, "Double is null");
    // jmethodID double_ctor = env.GetMethodID(Double, "<init>".ptr, "(D)V".ptr);
    jmethodID double_ctor = env.GetMethodID(Double, "<init>".ptr, "(D)V".ptr);
    assert(double_ctor !is null, "double_ctor is null");
    jmethodID double_toString = env.GetMethodID(Double, "toString".ptr, "()Ljava/lang/String;".ptr);
    assert(double_toString !is null, "double_toString is null");

    jclass DoubleNumeric = env.FindClass("com/tinyrenderer/demo/numeric/DoubleNumeric".ptr);
    assert(DoubleNumeric !is null, "class is null");
    jmethodID toString = env.GetMethodID(DoubleNumeric, "toString".ptr, "()Ljava/lang/String;".ptr);
    assert(toString !is null, "toString is null");
    jmethodID doubleNumeric_ctor = env.GetMethodID(DoubleNumeric, "<init>".ptr, "(Ljava/lang/Double;)V".ptr);
    assert(doubleNumeric_ctor !is null, "doubleNumeric_ctor is null");
    jobject pi = env.NewObject(Double, double_ctor, 3.14);
    jobject dn = env.NewObject(DoubleNumeric, doubleNumeric_ctor, pi);
    const(char)* nativeString = cast(const(char)*)calloc(100, char.sizeof);
    jstring javaString = env.CallObjectMethod(dn, toString, null);
    nativeString = env.GetStringUTFChars(javaString, null);
    printf("res2: %s\n", nativeString);
    env.ReleaseStringUTFChars(javaString, nativeString);
}

int main()
{
    JavaVM *jvm;
    JNIEnv *env = create_vm(&jvm);
    if(env == null)
        return 1;
    invoke_class(env);
    return 0;
}
