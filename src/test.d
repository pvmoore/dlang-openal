import std.stdio;

import openal;

void main() {
	writeln("Testing OpenAL");

    auto al = new OpenAL();

    auto src1 = al.createSource()
                  .setBuffer(al.loadBuffer("/pvmoore/_assets/sounds/trumpet.wav"))
                  .setLooping()
                  .play();


    auto src2 = al.createSource()
                  .setBuffer(al.loadBuffer("/pvmoore/_assets/sounds/intro.wav"))
                  .play();


    src2.wait();

    src1.setLooping(false);
    src1.wait();

    al.destroy();
}
