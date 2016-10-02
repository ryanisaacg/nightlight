import arcade.geom;
import derelict.sdl2.sdl;
import draw;
import entity;
import logic;
import std.conv;
import std.stdio;
import std.string;

void sdl_check(bool check) {
	if(check)
		writefln("SDL Error: %s\n", SDL_GetError());
}

SDL_Texture *load(SDL_Renderer *renderer, string path) {
	SDL_Surface *surface = SDL_LoadBMP(path.toStringz());
	sdl_check(surface == null);
	SDL_Texture *texture = SDL_CreateTextureFromSurface(renderer, surface);
	sdl_check(texture == null);
	SDL_FreeSurface(surface);
	return texture;
}

void main() {
    DerelictSDL2.load();
    sdl_check(SDL_Init(SDL_INIT_VIDEO) < 0);
    SDL_Window *window = SDL_CreateWindow("Project Nightlight", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 640, 480, SDL_WINDOW_SHOWN);
    sdl_check(window == null);
    SDL_Renderer *renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
	sdl_check(renderer == null);
    
    auto draw = Renderer(load(renderer, "img/block.bmp"), renderer);
    State state;
    state.entities.length = 1;
    state.entities[0] = Entity(Rect(0, 0, 32, 32), Vector2(1, 1));
    
    bool loop = true;
    
    while(loop) {
		SDL_Event e;
		while(SDL_PollEvent(&e)) {
			switch(e.type) {
			case SDL_QUIT:
				loop = false;
				break;
			default:
				continue;
			}
		}
		tick(&state);
		SDL_RenderClear(renderer);
		draw.draw(&state);
		SDL_RenderPresent(renderer);
		SDL_Delay(16);
	}
    SDL_DestroyWindow(window);
    SDL_Quit();
}
