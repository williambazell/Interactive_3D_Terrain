## Overview

This project is an interactive elevation map visualization tool that allows users to explore terrain data through multiple synchronized views. This Java-based application, built using the Processing framework, enables users to draw custom trails on elevation maps, add waypoints, and analyze terrain profiles in real-time.

## Features

- **Interactive 2D Map View**: Pan, zoom, and draw custom trails on elevation maps with intuitive mouse controls
- **3D Spatial Visualization**: Rotating 3D mesh representation of terrain with color-coded elevation data
- **Elevation Path Profile**: Dynamic cross-section view showing elevation changes along drawn trails
- **Elevation Histogram**: Statistical visualization of terrain elevation distribution
- **Waypoint Management**: Add and remove waypoints along trails with synchronized updates across all views
- **Multi-Map Support**: Pre-loaded with various maps including Asheville, Minneapolis, UMN campus, and more
- **Real-time Hover Indicators**: Visual feedback showing elevation data as you hover over trails

## Prerequisites

Before running this application, ensure you have the following installed:

- **[Processing](https://processing.org/download/)**: download the latest version for your operating system.

## Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/williambazell/Interactive_3D_Terrain.git
   ```

## Running the Application

1. **Open the project in Processing:**

   - Launch the Processing IDE
   - Go to `File > Open`
   - Navigate to the project directory and open `MyTrail.pde`

2. **Select a map (optional):**

   - Open `Application.pde`
   - Uncomment your desired map on lines 21-25:
     ```java
     model = new MapModel("colored_ashville.jpg");  // Currently active
     //model = new MapModel("minneapolis.jpg");
     //model = new MapModel("umn.jpg");
     //model = new MapModel("flower.jpg");
     //model = new MapModel("sunflowers.png");
     ```

3. **Run the sketch:**

   - Click the "Run" button (▶️) in the Processing IDE to start the application

## Usage

### Drawing Trails

- **Left-click and drag** on the 2D map view to draw a custom trail
- The trail will appear in red across all views simultaneously

### Managing Waypoints

- **Left-click** on an existing trail to add a blue waypoint
- **Left-click** on an existing waypoint to remove it
- Waypoints can be added/removed from both the Map View and Elevation Path View

### Navigation

- **Right-click or middle-click and drag** to pan the 2D map view
- **Scroll wheel** over the map view to zoom in/out
- **Scroll wheel** over the 3D view to adjust zoom level
- The 3D view automatically rotates for optimal terrain visualization

### Viewing Elevation Data

- **Hover** over a trail to see:
  - Precise coordinates in the Map View
  - Elevation indicator (orange bar) in all views
  - Corresponding position on the elevation histogram

## Technical Details

This project is a Java-based application developed using the Processing framework, which provides a simplified Java environment for visual programming. The application follows a Model-View-Controller (MVC) architecture:

- **Model** (`MapModel.pde`, `Model.pde`): Manages elevation map data, trail paths, and waypoints
- **Views** (`MapView.pde`, `Spatial3DView.pde`, `ElevationPathView.pde`, `HistogramView.pde`): Render different visualizations of the terrain data
- **Controller** (`Controller.pde`): Handles user input and synchronizes updates across all views

### Key Components

- **Elevation Map Processing**: Converts grayscale height maps to elevation data with customizable ranges
- **3D Rendering**: Uses Processing's P3D renderer with triangle strip meshes for terrain visualization
- **Real-time Computation**: Calculates distance metrics, elevation statistics, and histogram distributions on-the-fly
- **Coordinate Mapping**: Translates between screen space, map space, and 3D world space for precise interaction

### Application Window

The application window (1600x800) is divided into four synchronized views:
- **Top-left**: 2D Map View with pan/zoom controls
- **Top-right**: 3D Spatial View with rotating terrain mesh
- **Bottom-left**: Elevation Path View showing trail cross-section
- **Bottom-right**: Elevation Histogram with distribution analysis

## Notes

- This application requires Processing's P3D renderer for 3D visualization
- All `.pde` files must be in the same directory for Processing to recognize them as part of the same sketch
- Map images in the `data/` folder use brightness values to represent elevation (darker = lower, lighter = higher)
- Elevation values are normalized between 0.0 and 1.0, then mapped to real-world elevations (2300m - 2400m range)

## Examples

### Visualization with Trail Drawn
<img width="1596" height="825" alt="example_1" src="https://github.com/user-attachments/assets/ee17dd44-b04b-4ed4-a45c-a2957aee048b" />

### Trail with Waypoints
<img width="1595" height="825" alt="example_2" src="https://github.com/user-attachments/assets/eb29bb05-3f0d-4035-966f-ca3bd12e971d" />


## Contact

For questions or issues, please contact williambazell@yahoo.com

