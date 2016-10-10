import multimedia.graphics;

import entity;

void draw(Window window, State state) {
    static Texture effectTex = Texture(window.draw, window.width, window.height, true);
    Renderer draw = window.draw;
    //Draw the lighting created by the entities
    void lighting_overlay(Entity highlight) {
		//Set up render state
        draw.setTarget(effectTex);
        draw.mode = BlendMode.None;
        draw.setColor(0, 0, 0, 230);
		draw.fillRect(0, 0, window.width, window.height);
		//Render the blackened area
		//Render the highlighted area
		//TODO: Render in circle
		Rect bounds = highlight.bounds;
        int[3] alphas = [200, 128, 0]; // the alphas of each level of shadow
        for(int i = 0; i < 3; i ++) {
            draw.setColor(0, 0, 0, alphas[i]);
            int off = 90 - i * 30; //the offset of the lighting size
            draw.fillRect(cast(int)bounds.x - off, cast(int)bounds.y - off, cast(int)bounds.w + off * 2, cast(int)bounds.h + off * 2);
        }
        draw.display();
		//Draw the effect target over the screen
		draw.setTarget(window);
        draw.mode = BlendMode.Blend;
        draw.draw(effectTex, 0, 0, window.width, window.height);
	}
    //Draw the window background
    draw.setColor(128, 128, 128, 255);
    draw.clear();
    //Draw the entities
    for(int i = 0; i < state.amount; i++) {
        Entity e = state.entities[i];
        draw.draw(e.texture, e.x, e.y, e.width, e.height);
    }
    //Draw the tiles
    for(int x = 0; x < state.tiles.width; x += 32) {
        for(int y = 0; y < state.tiles.height; y += 32) {
            auto tex = state.tiles.get(Vector2(x, y));
            if(!tex.isNull)
                draw.draw(tex, x, y, 32, 32);
        }
    }
    //Draw the lighting
    lighting_overlay(state.entities[0]);
    //Finish drawing
    draw.display();
}