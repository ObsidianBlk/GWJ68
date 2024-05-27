extends UIControl


# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _page_idx : int = 0
var _pageList : Array[Control] = []

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _page_01: MarginContainer = %Page_01
@onready var _page_02: MarginContainer = %Page_02
@onready var _page_03: MarginContainer = %Page_03
@onready var _page_04: MarginContainer = %Page_04
@onready var _page_05: MarginContainer = %Page_05
@onready var _page_06: MarginContainer = %Page_06
@onready var _page_07: MarginContainer = %Page_07
@onready var _page_08: MarginContainer = %Page_08
@onready var _page_09: MarginContainer = %Page_09
@onready var _page_10: MarginContainer = %Page_10
@onready var _page_11: MarginContainer = %Page_11


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	_pageList.assign([
		_page_01,
		_page_02,
		_page_03,
		_page_04,
		_page_05,
		_page_06,
		_page_07,
		_page_08,
		_page_09,
		_page_10,
		_page_11
	])

# ------------------------------------------------------------------------------
# "Virtual" Private Methods
# ------------------------------------------------------------------------------
func _visibility_updating(data : Dictionary) -> void:
	if not visible:
		_page_idx = 0
		_PageToIndex()

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _PageToIndex() -> void:
	for i in range(_pageList.size()):
		_pageList[i].visible = (i == _page_idx)

func _PageUp() -> void:
	if _pageList.size() <= 0: return
	_pageList[_page_idx].visible = false
	_page_idx += 1
	if _page_idx >= _pageList.size():
		_page_idx = 0
	_pageList[_page_idx].visible = true

func _PageDown() -> void:
	if _pageList.size() <= 0: return
	_pageList[_page_idx].visible = false
	_page_idx -= 1
	if _page_idx < 0:
		_page_idx = _pageList.size() - 1
	_pageList[_page_idx].visible = true

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_btn_prev_page_pressed() -> void:
	_PageDown()

func _on_btn_next_page_pressed() -> void:
	_PageUp()

func _on_btn_back_pressed() -> void:
	request(UILayer.REQUEST_CLOSE_UI)
