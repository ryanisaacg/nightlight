import arcade.geom;
import derelict.sdl2.sdl;
import std.conv;
import std.stdio;
import std.string;

import app;
import entity;

struct Window {
	SDL_Window *window;
	SDL_Renderer *renderer;
	SDL_Texture *effect_target;
	int WIDTH, HEIGHT;
	bool open = true;
	bool[SDL_Scancode] keys;
	
	this(string title, int width, int height) {
		WIDTH = width;
		HEIGHT = height;
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
	
	///Checks if the window should remain open
	bool stayOpen() {
		return open;
	}
	
	///Check all the events in the event queue
	void checkEvents() {
		SDL_Event e;
		while(SDL_PollEvent(&e)) {
			switch(e.type) {
			case SDL_QUIT:
				open = false;
				break;
			case SDL_KEYDOWN:
				keys[e.key.keysym.scancode] = true;
				if(e.key.keysym.scancode == SDL_SCANCODE_F5)
					load_config();
				break;
			case SDL_KEYUP:
				keys.remove(e.key.keysym.scancode);
				break;
			default:
				continue;
			}
		}
	}
	
	///Draw a colored rectangle
	private void draw_rect(int x, int y, int width, int height, SDL_Color color) {
		SDL_Rect rect = SDL_Rect(x, y, width, height);
		SDL_SetRenderDrawColor(renderer, color.r, color.g, color.b, color.a);
		SDL_RenderFillRect(renderer, &rect);
	}
	
	///Draw the lighting overlay on the game
	private void lighting_overlay(Entity highlight) {
		//Set up render state
		SDL_SetRenderTarget(renderer, effect_target);
		SDL_SetRenderDrawBlendMode(renderer, SDL_BLENDMODE_NONE);
		//Render the blackened area
		draw_rect(0, 0, WIDTH, HEIGHT, SDL_Color(0, 0, 0, 230));
		//Render the highlighted area
		//TODO: Render in circle
		SDL_Rect bounds = convert(highlight.bounds);
		draw_rect(bounds.x - 90, bounds.y - 90, bounds.w + 180, bounds.h + 180, SDL_Color(0, 0, 0, 200));
		draw_rect(bounds.x - 60, bounds.y - 60, bounds.w + 120, bounds.h + 120, SDL_Color(0, 0, 0, 128));
		draw_rect(bounds.x - 30, bounds.y - 30, bounds.w + 60, bounds.h + 60, SDL_Color(0, 0, 0, 0));
		//Draw the effect target over the screen
		SDL_SetRenderTarget(renderer, null);
		SDL_SetRenderDrawBlendMode(renderer, SDL_BLENDMODE_BLEND);
		SDL_RenderCopy(renderer, effect_target, null, null);
	}
		
	///Draw an entity
	private void draw_entity(Entity entity) {
		//Get the entity bounds converted to an SDL_Rect
		SDL_Rect target = convert(entity.bounds);
		//Draw the entity's texture
		SDL_RenderCopy(renderer, entity.texture, null, &target);
	}
	
	///Draw the entire state
	void draw(State state) {
		//Draw the window background
		SDL_SetRenderDrawColor(renderer, 128, 128, 128, 255);
		SDL_RenderClear(renderer);
		//Draw the entities
		for(int i = 0; i < state.amount; i++) draw_entity(state.entities[i]);
		//Draw the tiles
		for(int x = 0; x < state.tiles.width; x += 32) {
			for(int y = 0; y < state.tiles.height; y += 32) {
				auto tex = state.tiles.get(Vector2(x, y));
				if(!tex.isNull) {
					SDL_Rect target = SDL_Rect(x, y, 32, 32);
					SDL_RenderCopy(renderer, tex, null, &target);
				}
			}
		}
		//Draw the lighting
		lighting_overlay(state.entities[0]);
		//Finish drawing
		SDL_RenderPresent(renderer);
	}
	
	private SDL_Rect convert(Rect rect) {
		return SDL_Rect(cast(int)rect.x, cast(int)rect.y, cast(int)rect.width, cast(int)rect.height);
	}
	
	SDL_Texture *load(string path) {
		//Load surface from a file
		SDL_Surface *surface = SDL_LoadBMP(path.toStringz());
		sdl_check(surface == null, "Loading BMP file " ~ path);
		//Load texutre from surface
		SDL_Texture *texture = SDL_CreateTextureFromSurface(renderer, surface);
		sdl_check(texture == null, "Creating texture");
		//Clean up surface
		SDL_FreeSurface(surface);
		return texture;
	}
	
	private void sdl_check(bool check, string description) {
		if(check)
			writefln("SDL Error: %s failed (%s)\n", description, SDL_GetError());
	}
}
