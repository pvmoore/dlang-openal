module openal.alsource;

import openal.all;

final class ALSource {
    uint id;
    ALBuffer buffer;

    @property bool isPlaying() { return getState()==AL_PLAYING; }

    this() {
        alGenSources(1, &id);

        alSourcef(id, AL_PITCH, 1);
        alSourcef(id, AL_GAIN, 1);
        alSource3f(id, AL_POSITION, 0, 0, 0);
        alSource3f(id, AL_VELOCITY, 0, 0, 0);
        alSourcei(id, AL_LOOPING, AL_FALSE);

        //distance stuff
        alSourcef(id, AL_REFERENCE_DISTANCE, 1);
        alSourcef(id, AL_ROLLOFF_FACTOR, 1);
        alSourcef(id, AL_MAX_DISTANCE, 100);
    }
    void destroy() {
        alDeleteSources(1, &id);
    }
    /** AL_INITIAL, AL_PLAYING, AL_PAUSED, AL_STOPPED */
    int getState() {
        int state;
        alGetSourcei(id, AL_SOURCE_STATE, &state);
        return state;
    }
    auto setObjectSize(float s) {
        alSourcef(id, AL_REFERENCE_DISTANCE, s);
        return this;
    }
    auto setMaxDistance(float d) {
        alSourcef(id, AL_MAX_DISTANCE, d);
        return this;
    }
    auto setBuffer(ALBuffer b) {
        this.buffer = b;
        return this;
    }
    auto moveTo(float x, float y, float z) {
        alSource3f(id, AL_POSITION, x,y,z);
        return this;
    }
    auto setLooping(bool loop=true) {
        alSourcei(id, AL_LOOPING, loop?AL_TRUE:AL_FALSE);
        return this;
    }
    auto setGain(float vol) {
        alSourcef(id, AL_GAIN, vol);
        return this;
    }
    auto setPitch(float p) {
        alSourcef(id, AL_PITCH, p);
        return this;
    }
    auto play() {
        assert(buffer);
        alSourcei(id, AL_BUFFER, buffer.id);
        alSourcePlay(id);
        return this;
    }
    auto wait() {
        if(isPlaying) {
            while(isPlaying) {
                Thread.sleep(dur!("msecs")(50));
            }
            Thread.sleep(dur!("msecs")(400));
        }
        return this;
    }
    auto rewind() {
        alSourceRewind(id);
        return this;
    }
    auto pause() {
        alSourcePause(id);
        return this;
    }
    auto resume() {
        play();
        return this;
    }
    auto stop() {
        alSourceStop(id);
        return this;
    }
}

