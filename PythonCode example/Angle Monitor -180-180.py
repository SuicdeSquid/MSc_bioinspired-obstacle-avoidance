import bpy
import math
from mathutils import Vector
import os

# Define the camera
camera = bpy.context.scene.camera

# List of object names to calculate angles for
object_names = ['Pillar1', 'Pillar2', 'Pillar3','Pillar4']  # Update with your object names

def calculate_angles(scene):
    # Ensure the camera is valid
    if camera is None:
        print("Camera not found in the scene")
        return

    angles = {}
    for obj_name in object_names:
        object = bpy.context.scene.objects.get(obj_name)
        
        if object is None:
            print(f"Object '{obj_name}' not found in the scene")
            continue

        # Calculate the direction vector from camera to object
        direction_vector = object.location - camera.location
        direction_vector.normalize()

        # Get the camera's forward vector (negative Z axis)
        camera_forward_vector = camera.matrix_world.to_3x3() @ Vector((0.0, 0.0, -1.0))
        camera_forward_vector.normalize()
        
        # Calculate the angle between the vectors
        dot_product = direction_vector.dot(camera_forward_vector)
        angle_rad = math.acos(dot_product)
        
        # Calculate the cross product to determine the sign of the angle
        cross_product = camera_forward_vector.cross(direction_vector)
        if cross_product.z < 0:
            angle_rad = -angle_rad
        
        # Convert radians to degrees
        angle_deg = math.degrees(angle_rad)
        
        # Store the angle in the object's custom properties
        camera[f"Angle_{obj_name}"] = angle_deg
        angles[obj_name] = angle_deg
        
    frame_number = scene.frame_current
    save_angles_to_file(frame_number, angles)

def save_angles_to_file(frame_number, angles):
    file_path = os.path.join(bpy.path.abspath("//"), "angles -180-180.txt")
    with open(file_path, 'a') as file:
        file.write(f"Frame {frame_number}:\n")
        for obj_name, angle in angles.items():
            file.write(f"  {obj_name}: {angle:.4f}\n")
        file.write("\n")

# Append the function to the frame change handler
bpy.app.handlers.frame_change_post.clear() 
bpy.app.handlers.frame_change_post.append(calculate_angles)
