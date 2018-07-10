module openal.util.wav;

import openal.all;

bool isMono(WavFile wav) {return !isStereo(wav); }

bool isStereo(WavFile wav) {
    return alFormat(wav) == AL_FORMAT_STEREO8 ||
           alFormat(wav) == AL_FORMAT_STEREO16;
}

ALenum alFormat(WavFile wav) {
    switch(wav.numChannels() + wav.bitsPerSample()) {
        case 9  : return AL_FORMAT_MONO8;
        case 10 : return AL_FORMAT_STEREO8;
        case 17 : return AL_FORMAT_MONO16;
        case 18 : return AL_FORMAT_STEREO16;
        default : throw new Exception("Unsupported WAV format");
    }
    assert(false);
}
ALBuffer createALBuffer(WavFile wav) {
    auto b = new ALBuffer();
    b.add(wav.bytes.ptr,
        cast(uint)wav.bytes.length,
        alFormat(wav),
        wav.frequency
    );
    return b;
}
