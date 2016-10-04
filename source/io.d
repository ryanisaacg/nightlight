import arcade.geom;
import derelict.sdl2.sdl;
import std.conv;
import std.stdio;
import std.string;

import entity;


struct Window {
	SDL_Window *window;
	SDL_Renderer *renderer;
	bool open = true;
	bool[SDL_Scancode] keys;
	
	this(string title) {
		DerelictSDL2.load();
		sdl_check(SDL_Init(SDL_INIT_VIDEO) < 0, "SDL Initialization");
		window = SDL_CreateWindow(title.toStringz(), SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 640, 480, SDL_WINDOW_SHOWN);
		sdl_check(window == null, "Window creation");
		renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
		sdl_check(renderer == null, "Renderer creation");
	}
	
	~this() {
		SDL_DestroyWindow(window);
		SDL_Quit();
	}
	
	bool stayOpen() {
		return open;
	}
	
	void checkEvents() {
		SDL_Event e;
		while(SDL_PollEvent(&e)) {
			switch(e.type) {
			case SDL_QUIT:
				open = false;
				break;
			case SDL_KEYDOWN:
				keys[e.key.keysym.scancode] = true;
				break;
			case SDL_KEYUP:
				keys.remove(e.key.keysym.scancode);
				break;
			default:
				continue;
			}
		}
	}
	
	void draw_entity(Entity entity) {
		SDL_Rect target = convert(entity.bounds);
			SDL_RenderCopy(renderer, entity.texture, null, &target);
	}
	
	void draw(State state) {
		SDL_RenderClear(renderer);
		foreach(entity; state.entities) draw_entity(entity);
		draw_entity(state.player);
		for(int x = 0; x < state.tiles.width; x += 32) {
			for(int y = 0; y < state.tiles.height; y += 32) {
				auto tex = state.tiles.get(Vector2(x, y));
				if(!tex.isNull) {
					SDL_Rect target = SDL_Rect(x, y, 32, 32);
					SDL_RenderCopy(renderer, tex, null, &target);
				}
			}
		}
		SDL_RenderPresent(renderer);
	}
	
	private SDL_Rect convert(Rect rect) {
		return SDL_Rect(cast(int)rect.x, cast(int)rect.y, cast(int)rect.width, cast(int)rect.height);
	}
	
	SDL_Texture *load(string path) {
		SDL_Surface *surface = SDL_LoadBMP(path.toStringz());
		sdl_check(surface == null, "Loading BMP file " ~ path);
		SDL_Texture *texture = SDL_CreateTextureFromSurface(renderer, surface);
		sdl_check(texture == null, "Creating texture");
		SDL_FreeSurface(surface);
		return texture;
	}
	
	private void sdl_check(bool check, string description) {
		if(check)
			writefln("SDL Error: %s failed (%s)\n", description, SDL_GetError());
	}
}
