import arcade.geom;
import derelict.sdl2.sdl;
import dini;
import std.conv;

import entity;
import logic;
import io;

void main() {
	auto gfx_cfg = Ini.Parse("config/graphics.ini");
	auto game_cfg = Ini.Parse("config/gameplay.ini");
	GameConfig config = {
		friction: to!float(game_cfg["controls"].getKey("friction")), 
		accel: to!float(game_cfg["controls"].getKey("accel")), 
		top_speed: to!float(game_cfg["controls"].getKey("top_speed")), 
		min_speed: to!float(game_cfg["controls"].getKey("min_speed")),
		gravity: to!float(game_cfg["physics"].getKey("gravity"))};
	auto window_cfg = gfx_cfg["window"]; 
    auto window = Window(window_cfg.getKey("title"), to!int(window_cfg.getKey("width")), 
		to!int(window_cfg.getKey("height")));
    
    SDL_Texture *block = window.load("img/block.bmp");
    SDL_Texture *player = window.load( "img/player.bmp");
    
    State state = State(10, Entity(Rect(0, 0, 32, 32), Vector2(1, 1), player));
    state.tiles = new Tiles();
    state.tiles.put(block, Vector2(100, 100));
    state.add(Entity(Rect(0, 0, 32, 32), Vector2(1, 1), player));
    
    int frame_delay = 1000 / to!int(gfx_cfg["perf"].getKey("fps"));
    while(window.stayOpen) {
		window.checkEvents();
		tick(state, window.keys, config);
		window.draw(state);
		SDL_Delay(frame_delay);
	}
    
}
