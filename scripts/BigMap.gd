extends Node2D

var explored = []
var maze_ref = null
var maze_sz = 0
var player_pos = Vector2.ZERO
var exit_cell = Vector2i.ZERO
var cell_sz = 48
var items_ref: Array = []

func init_data(expl: Array, mz: Array, sz: int, pp: Vector2, exit: Vector2i, c: int, itms: Array):
	explored = expl
	maze_ref = mz
	maze_sz = sz
	player_pos = pp
	exit_cell = exit
	cell_sz = c
	items_ref = itms

func _draw():
	if maze_ref == null:
		return
	var vs = get_viewport().get_visible_rect().size
	var s = min(vs.x / float(maze_sz), vs.y / float(maze_sz))
	var ox = (vs.x - maze_sz * s) / 2.0
	var oy = (vs.y - maze_sz * s) / 2.0
	# 画背景（删除场景里会盖住 _draw 的 MapBG ColorRect 子节点，改由我们自己先画）
	draw_rect(Rect2(0, 0, vs.x, vs.y), Color(0.18, 0.16, 0.14, 1))

	for y in range(maze_sz):
		for x in range(maze_sz):
			var rx = ox + x * s
			var ry = oy + y * s
			if not explored[y][x]:
				# 未探索：黑色迷雾
				draw_rect(Rect2(rx, ry, s, s), Color(0, 0, 0, 1))
			elif maze_ref[y][x]:
				# 墙·已探索
				draw_rect(Rect2(rx, ry, s, s), Color(0.1, 0.12, 0.3, 1))
			else:
				# 通路·已探索
				draw_rect(Rect2(rx, ry, s, s), Color(0.72, 0.66, 0.52, 1))

	draw_rect(Rect2(ox + exit_cell.x * s, oy + exit_cell.y * s, s, s), Color(0.2, 0.9, 0.3, 1))

	for item in items_ref:
		var ix = int(item["pos"].x / cell_sz)
		var iy = int(item["pos"].y / cell_sz)
		if not explored[iy][ix]:
			continue
		var ic: Color
		match item["type"]:
			0:
				ic = Color.CYAN
			1:
				ic = Color.GREEN
			2:
				ic = Color.RED
			3:
				ic = Color.MAGENTA
			4:
				ic = Color.YELLOW
		draw_circle(Vector2(ox + ix * s + s/2, oy + iy * s + s/2), max(3.0, s * 0.5), ic)

	var px = ox + player_pos.x / cell_sz * s
	var py = oy + player_pos.y / cell_sz * s
	draw_circle(Vector2(px, py), max(5.0, s * 0.7), Color(0.1, 0.6, 1, 1))
