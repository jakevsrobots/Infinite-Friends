#!/usr/bin/python

import os, sys
import commands
from xml.dom import minidom

#--------------------------------------
BASE_PATH = os.path.join(os.path.dirname(__file__), 'asset_library')
ASSET_BASE = '/../data/'
ASSET_XML_FILE = os.path.join(BASE_PATH, '../data/assets.xml')
OUTPUT_SWF_PATH = 'output/InfiniteFriends.swf'
MAIN_CLASS_PATH = 'src/friends/Main.as'
OUTPUT_WIDTH = 640
OUTPUT_HEIGHT = 480

MAP_SRC_DIR = os.path.join(BASE_PATH, '../data/maps')
MAP_COMPILED_DIR = os.path.join(BASE_PATH, '../data/maps/compiled')
TILE_LAYER_NAMES = ["backgroundTiles", "foregroundTiles"]
#--------------------------------------

def main():
    #build_assets()
    #compile_levels()
    build_swf()

def compile_levels():
    """
    Flatten OGMO's XML tilemaps into comma-separated strings. This is
    done in order to cut down processing at runtime - parsing tilemap
    data from a list of xml nodes into a CSV is too costly to do at
    runtime without noticeable lag.
    """
    
    for ogmo_filename in [x for x in os.listdir(MAP_SRC_DIR) if x.endswith('.oel')]:
        ogmo_path = os.path.join(MAP_SRC_DIR, ogmo_filename)
        ogmo_flattened_path = os.path.join(MAP_COMPILED_DIR, ogmo_filename)

        if os.path.exists(ogmo_flattened_path):
            if os.path.getmtime(ogmo_flattened_path) > os.path.getmtime(ogmo_path):
                sys.stdout.write("--%s up to date\n" % ogmo_flattened_path)
                continue
        
        flatten_ogmo_tilemaps(ogmo_path, ogmo_flattened_path)

def flatten_ogmo_tilemaps(ogmo_path, ogmo_flattened_path):
    ogmo_dom = minidom.parse(ogmo_path)

    map_data = dict(ogmo_dom.getElementsByTagName('level')[0].attributes.items())
    map_data['width'] = ogmo_dom.getElementsByTagName('width')[0].firstChild.data
    map_data['height'] = ogmo_dom.getElementsByTagName('height')[0].firstChild.data
    
    # load tiles
    for tile_layer_name in TILE_LAYER_NAMES:
        try:
            map_data[tile_layer_name] = dict(ogmo_dom.getElementsByTagName(tile_layer_name)[0].attributes.items())
        except IndexError:
            # no tile layer by this name found on this map
            continue
        
        map_data[tile_layer_name]['tiles'] = ''

        tileWidth = int(map_data[tile_layer_name]['tileWidth'])
        tileHeight = int(map_data[tile_layer_name]['tileHeight'])
        widthInTiles = int(map_data['width']) / tileWidth
        heightInTiles = int(map_data['height']) / tileHeight

        tiles = {}
        for tileNode in ogmo_dom.getElementsByTagName(tile_layer_name)[0].getElementsByTagName('tile'):
            tileId = tileNode.getAttribute('id')
            tileX = int(tileNode.getAttribute('x')) / tileWidth
            tileY = int(tileNode.getAttribute('y')) / tileHeight
            tiles[str(tileX) + '@' + str(tileY)] = tileId

        for y in range(0, heightInTiles):
            for x in range(0, widthInTiles):
                tileId = tiles.get(str(x) + '@' + str(y), '0')
                map_data[tile_layer_name]['tiles'] += tileId
                map_data[tile_layer_name]['tiles'] += ","
            map_data[tile_layer_name]['tiles'] += "\n"

        # clear out old tiles node & add a new flattened one
        ogmo_dom.getElementsByTagName(tile_layer_name)[0].childNodes[:] = [] # shorcut to clear all child nodes
        flattenedTextNode = ogmo_dom.createTextNode(map_data[tile_layer_name]['tiles'])
        ogmo_dom.getElementsByTagName(tile_layer_name)[0].appendChild(flattenedTextNode)

    f = open(ogmo_flattened_path, 'w')
    f.write(ogmo_dom.toxml())
    f.close()
        
def build_assets():
    """
    Build the 'AssetLibrary' class file.
    """

    # templates
    template = open(os.path.join(BASE_PATH, 'AssetLibrary.as.template'), 'r').read()

    embed_templates = {
        'image': "[Embed(source='%(asset_path)s')] private var %(asset_class_name)s:Class;\n",
        'mp3': "[Embed(source='%(asset_path)s')] private var %(asset_class_name)s:Class;\n",        
        'xml': "[Embed(source='%(asset_path)s', mimeType=\"application/octet-stream\")] private var %(asset_class_name)s:Class;\n"
    }
    
    library_element_template = "'%(asset_id)s': %(asset_class_name)s"

    # load+parse asset xml
    complete_asset_embed_code = ""
    complete_asset_data_code = ""
    asset_dom = minidom.parse(ASSET_XML_FILE)
    
    asset_nodes = list(asset_dom.getElementsByTagName('asset'))
    
    for asset_node in asset_nodes:
        asset_attrs = dict(asset_node.attributes.items())
        asset_embed_code = embed_templates[asset_attrs['type']] % {
            'asset_class_name': asset_attrs['name'],
            'asset_path': ASSET_BASE + asset_attrs['file']
        }

        complete_asset_embed_code += asset_embed_code
        
        asset_data_code = library_element_template % {
            'asset_id': asset_attrs['name'],
            'asset_class_name': asset_attrs['name']
        }

        complete_asset_data_code += asset_data_code

        if asset_nodes.index(asset_node) == len(asset_nodes) - 1:
            complete_asset_data_code += "\n"
        else:
            complete_asset_data_code += ",\n"
            
    output = template % {
        'asset_embeds': complete_asset_embed_code,
        'asset_data': complete_asset_data_code
    }
        
    # render
    output_f = open(os.path.join(BASE_PATH, 'AssetLibrary.as'), 'w')
    output_f.write(output)

def build_swf():
    build_data = {
        'main_class_path': MAIN_CLASS_PATH,
        'output_swf_path': OUTPUT_SWF_PATH,
        'movie_width': OUTPUT_WIDTH,
        'movie_height': OUTPUT_HEIGHT
     }
    
    if os.name == 'posix':
        # add -debug to get traces on command line
        build_command = "mxmlc %(main_class_path)s -source-path=src/ -output %(output_swf_path)s -static-link-runtime-shared-libraries -default-background-color 0 -default-size %(movie_width)s %(movie_height)s && flashplayer_10 %(output_swf_path)s" % build_data
    elif os.name == 'nt':
        build_command = 'mxmlc.exe %(main_class_path)s -source-path=src/ -output %(output_swf_path)s -static-link-runtime-shared-libraries -default-size %(movie_width)s %(movie_height)s && /c/flex4/runtimes/player/10/win/FlashPlayer.exe %(output_swf_path)s' % build_data
    else:
        print "no build command found for OS ", os.name
        return
        
    sys.stdout.write(commands.getoutput(build_command) + "\n")
    
if __name__ == '__main__':
    main()
