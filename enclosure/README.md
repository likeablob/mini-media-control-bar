# mini-media-control-bar/case

## Prerequisites

- OpenSCAD (nightly build) 2025.02
- GNU Make
- ImageMagick
- BOSL2 (included as submodule)

## Build

```sh
$ git submodule update --init --recursive

# Generate .scad and .stl files.
$ make all -B

# Generate thumbnail images.
$ make images -B
```

## Parts

|                                     | STL                                  |
| ----------------------------------- | ------------------------------------ |
| ![](./images/mmcb_top_thumb.png)    | [mmcb_top.stl](./mmcb_top.stl)       |
| ![](./images/mmcb_bottom_thumb.png) | [mmcb_bottom.stl](./mmcb_bottom.stl) |
| ![](./images/mmcb_knob_thumb.png)   | [mmcb_knob.stl](./mmcb_knob.stl)     |

## Print conditions

- 1.75mm PLA
- 0.2mm layer height
