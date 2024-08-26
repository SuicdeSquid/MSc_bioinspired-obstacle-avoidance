import bpy
import mathutils
import os

# 摄像机的名字
camera_name = "Camera"

# 目标物体的名字列表
target_names = ["Pillar1", "Pillar2", "Pillar3", "Pillar4"]

# 获取摄像机对象
camera = bpy.data.objects[camera_name]

# 初始化目标对象字典和自定义属性
targets = {}
for target_name in target_names:
    target = bpy.data.objects[target_name]
    targets[target_name] = target
    # 检查并添加自定义属性
    if f"Distance_{target_name}" not in camera:
        camera[f"Distance_{target_name}"] = 0.0

# 定义一个处理函数来更新距离并保存到文件
def update_distances(scene):
    camera_location = camera.matrix_world.translation
    distances = {}
    for target_name, target in targets.items():
        target_location = target.matrix_world.translation
        distance = (camera_location - target_location).length
        camera[f"Distance_{target_name}"] = distance
        distances[target_name] = distance
    
    # 将距离数据保存到文本文件
    frame_number = scene.frame_current
    save_distances_to_file(frame_number, distances)

def save_distances_to_file(frame_number, distances):
    file_path = os.path.join(bpy.path.abspath("//"), "distances.txt")
    with open(file_path, 'a') as file:
        file.write(f"Frame {frame_number}:\n")
        for target_name, distance in distances.items():
            file.write(f"  {target_name}: {distance:.4f}\n")
        file.write("\n")

# 将处理函数附加到frame_change_post处理程序
bpy.app.handlers.frame_change_post.clear()  # 清除所有现有的处理程序（可选）
bpy.app.handlers.frame_change_post.append(update_distances)

print("Distance monitor script for multiple targets initialized and data will be saved to distances.txt.")

