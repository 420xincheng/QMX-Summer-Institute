package com.qmx.work6;

public class Application {
    public Application() {
    }

    public static void main(String[] args) {
        Simulator simulator = new Simulator();
        simulator.playSound(new Dog());
        simulator.playSound(new Cat());
    }
}
