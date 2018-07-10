module openal.openal;

import openal.all;

final class OpenAL {
private:
    ALCdevice* device;
    ALCcontext* context;
    ALBuffer[string] buffers;
    ALSource[uint] sources;
public:
    this() {
        log("Creating OpenAL");
        DerelictAL.load();
        initialise();
    }
    void destroy() {
        log("Destroying OpenAL");
        log("Destroying %s sources", sources.length);
        log("Destroying %s buffers", buffers.length);
        foreach(s; sources.values) s.destroy();
        foreach(b; buffers.values) b.destroy();
        destroyContext();
        closeDevice();
        DerelictAL.unload();
    }
    ALBuffer loadBuffer(string filename) {
        ALBuffer buffer;
        ALBuffer* p = (filename in buffers);
        if(!p) {
            auto wav = new WavFile(filename);
            log("length = %s millis" , wav.lengthMillis);
            buffer = wav.createALBuffer();
            buffers[filename] = buffer;
        } else {
            buffer = *p;
        }
        return buffer;
    }
    void unloadBuffer(string filename) {
        auto p = filename in buffers;
        if(p) {
            buffers.remove(filename);
            (*p).destroy();
        }
    }
    ALSource createSource() {
        auto s = new ALSource();
        sources[s.id] = s;
        return s;
    }
    void destroySource(ALSource src) {
        auto s = src.id in sources;
        if(s) {
            sources.remove(src.id);
            (*s).destroy();
        }
    }
private:
    void initialise() {
        log("ALC_ENUMERATION_EXT   = %s", alcIsExtensionPresent(null, "ALC_ENUMERATION_EXT"));
        log("ALC_ENUMERATE_ALL_EXT = %s", alcIsExtensionPresent(null, "ALC_ENUMERATE_ALL_EXT"));

        openDefaultDevice();
        createContext();

        alListener3f(AL_POSITION, 0,0,0);                                  //Set position of the listener
        alListener3f(AL_VELOCITY, 0,0,0);                                  //Set velocity of the listener
        alListenerfv(AL_ORIENTATION, [
            0.0f, 0.0f, -1.0f,  // look at
            0.0f, 1.0f, 0.0f    // up
        ].ptr);


        alDistanceModel(AL_EXPONENT_DISTANCE);
    }
    void checkError() {
        ALCenum err = alGetError();
        if(err) {
            logerror("[OpenAL ERROR] %s", err);
        }
    }
    bool openDefaultDevice() {
        device = alcOpenDevice("");
        if(!device) {
            logerror("Could not create OpenAL device");
            return false;
        }
        return true;
    }
    void closeDevice() {
        if(device) alcCloseDevice(device);
        device = null;
    }
    bool createContext() {
        // context attributes, 2 zeros to terminate
        ALint[] attribs = [
            0, 0
        ];
        ALCcontext* context = alcCreateContext(device, attribs.ptr);
        if(!context) {
            logerror("Could not create OpenAL context");
            return false;
        }
        if(!alcMakeContextCurrent(context)) {
            logerror("Could not enable OpenAL context.");
            return false;
        }
        log("OpenAL version: %s", fromStringz(alGetString(AL_VERSION)));
        log("OpenAL vendor: %s", fromStringz(alGetString(AL_VENDOR)));
        log("OpenAL renderer: %s", fromStringz(alGetString(AL_RENDERER)));

        //log("OpenAL default: %s", fromStringz(alGetString(ALC_DEFAULT_DEVICE_SPECIFIER)));

        listDevices();
        return true;
    }
    void destroyContext() {
        if(context) {
            alcMakeContextCurrent(null);
            alcDestroyContext(context);
            context = null;
        }
    }
    void listDevices() {
        const(ALCchar)* devices = alcGetString(null, ALC_DEVICE_SPECIFIER);
        log("Devices {");
        while(devices && *devices) {
            auto s = fromStringz(devices);
            log("\t%s", s);
            devices += strlen(devices)+1;
        }
        log("}");
    }
}

