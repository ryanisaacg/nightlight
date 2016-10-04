import arcade.geom;
import derelict.sdl2.sdl;
import std.conv;
import std.stdio;
import std.string;

import entity;


const int WIDTH = 640, HEIGHT = 480;

struct Window {
	SDL_Window *window;
	SDL_Renderer *renderer;
	SDL_Texture *effect_target;
	
	bool open = true;
	bool[SDL_Scancode] keys;
	
	this(string title) {
		DerelictSDL2.load();
		sdl_check(SDL_Init(SDL_INIT_VIDEO) < 0, "SDL Initialization");
		window = SDL_CreateWindow(title.toStringz(), SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, WIDTH, HEIGHT, SDL_WINDOW_SHOWN);
		sdl_check(window == null, "Window creation");
		renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
		sdl_check(renderer == null, "Renderer creation");
		effect_target = SDL_CreateTexture(renderer, SDL_PIXELFORMAT_RGBA8888, SDL_TEXTUREACCESS_TARGET, WIDTH, HEIGHT);
		sdl_check(renderer == null, "Effect texture creation");
		SDL_SetTextureBlendMode(effect_target, SDL_BLENDMODE_BLEND);
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
	
	///Draw the lighting overlay on the game
	private void lighting_overlay(Entity highlight) {
		//Set up render state
		SDL_SetRenderTarget(renderer, effect_target);
		SDL_SetRenderDrawBlendMode(renderer, SDL_BLENDMODE_NONE);
		//Render the blackened area
		SDL_SetRenderDrawColor(renderer, 0, 0, 0, 128);
		SDL_Rect screen = SDL_Rect(0, 0, WIDTH, HEIGHT);
		SDL_RenderFillRect(renderer, &screen);
		//Render the highlighted area
		//TODO: Render in circle
		SDL_SetRenderDrawColor(renderer, 0, 0, 0, 0);
		SDL_Rect highlighted_rect = convert(highlight.bounds);
		highlighted_rect.x -= 30;
		highlighted_rect.y -= 30;
		highlighted_rect.w += 60;
		highlighted_rect.h += 60;
		SDL_RenderFillRect(renderer, &highlighted_rect);
		//Draw the effect target over the screen
		SDL_SetRenderTarget(renderer, null);
		SDL_SetRenderDrawBlendMode(renderer, SDL_BLENDMODE_BLEND);
		SDL_RenderCopy(renderer, effect_target, null, &screen);
	}
		
	///Draw an entity
	private void draw_entity(Entity entity) {
		SDL_Rect target = convert(entity.bounds);
		SDL_RenderCopy(renderer, entity.texture, null, &target);
	}
	
	///Draw the entire state
	void draw(State state) {
		SDL_SetRenderDrawColor(renderer, 128, 128, 128, 255);
		SDL_RenderClear(renderer);
		foreach(entity; state.entities) draw_entity(entity);
		for(int x = 0; x < state.tiles.width; x += 32) {
			for(int y = 0; y < state.tiles.height; y += 32) {
				auto tex = state.tiles.get(Vector2(x, y));
				if(!tex.isNull) {
					SDL_Rect target = SDL_Rect(x, y, 32, 32);
					SDL_RenderCopy(renderer, tex, null, &target);
				}
			}
		}
		lighting_overlay(state.entities[0]);
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
