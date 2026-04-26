-- 常量定义模块

local Constants = {}

-- 身体核心部件列表（永远不隐藏）
Constants.BODY_CORE_PARTS = {
    "head", "torso", "humanoidrootpart", "neck", 
    "leftarm", "rightarm", "leftleg", "rightleg",
    "upperleg", "lowerleg", "leftfoot", "rightfoot"
}

-- 头部饰品关键词
Constants.HEAD_KEYWORDS = {
    "hat", "helmet", "cap", "hood", "beanie", "visor", "headband", "bandana",
    "hair", "wig", "hairstyle", "ponytail", "bun", "bangs", "mohawk", "bald",
    "longhair", "shorthair", "curly", "straighthair",
    "mask", "glasses", "goggles", "sunglasses", "eyewear", "spectacles", 
    "crown", "tiara", "halo", "horn", "antler", "headpiece", "headdress", 
    "veil", "bonnet", "beret", "fedora", "top hat", "headphones", "earmuffs",
    "head", "skull", "brain", "ear", "ears"
}

-- 颈部饰品关键词
Constants.NECK_KEYWORDS = {
    "necklace", "choker", "pendant", "collar", "scarf", "tie", "cravat", "bowtie"
}

-- 肩部饰品关键词（只用于识别肩部饰品）
Constants.SHOULDER_KEYWORDS = {
    "shoulder", "pauldron", "epaulette", "shoulderpad", "mantle", "spaulder"
}

-- 背面饰品关键词
Constants.BACK_KEYWORDS = {
    "back", "wing", "cloak", "cape", "pack", "quiver", "backpack", "tail"
}

-- 腰部饰品关键词
Constants.WAIST_KEYWORDS = {
    "waist", "belt", "hip", "buckle", "sash"
}

-- 正面饰品关键词
Constants.CHEST_KEYWORDS = {
    "chest", "front", "badge", "brooch", "ribbon", "medal", "breast", "armor", "vest"
}

-- 表情关键词
Constants.FACE_KEYWORDS = {
    "face", "emotion", "smile", "mouth", "eye", "brow", "eyebrow", "expression", "beard", "mustache"
}

return Constants
