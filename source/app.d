import derelict.sdl2.sdl;
import std.stdio;

void sdl_check(bool check) {
	if(check)
		writefln("SDL Error: %s\n", SDL_GetError());
}

void main() {
    DerelictSDL2.load();
    sdl_check(SDL_Init(SDL_INIT_VIDEO) < 0);
    SDL_Window *window = SDL_CreateWindow("Project Nightlight", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 640, 480, SDL_WINDOW_SHOWN);
    sdl_check(window == null);
    SDL_Delay(1000);
    SDL_DestroyWindow(window);
    SDL_Quit();
}
