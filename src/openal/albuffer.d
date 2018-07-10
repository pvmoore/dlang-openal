module openal.albuffer;

import openal.all;

final class ALBuffer {
    uint id;
    uint length;

    this() {
        alGenBuffers(1, &id);
    }
    void destroy() {
        alDeleteBuffers(1, &id);
    }
    void add(void* data, uint length, uint format, uint frequency) {
        alBufferData(
            id,
            format,
            data,
            length,
            frequency
        );
        this.length = length;
    }
    void add(WavFile wav) {
        add(wav.bytes.ptr,
            cast(uint)wav.bytes.length,
            wav.alFormat(),
            wav.frequency()
        );
    }
}


