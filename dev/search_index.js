var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = XPalm","category":"page"},{"location":"#XPalm","page":"Home","title":"XPalm","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for XPalm.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [XPalm]","category":"page"},{"location":"#XPalm.Female","page":"Home","title":"XPalm.Female","text":"Female(state)\n\nA female inflorescence, which has a state that can be either:\n\nInitiation: in initiation phase (cell division)\nAbortion\nFlowering\nBunch: the bunch of fruits is developping\nOleoSynthesis: the inflorescence is in the process of oleosynthesis\nScenescent: dead but still on the plant\nPruned: removed from the plant (e.g. harvested)\n\n\n\n\n\n","category":"type"},{"location":"#XPalm.Internode","page":"Home","title":"XPalm.Internode","text":"Internode(state)\n\nAn internode, which has a state of type InternodeState that can be either:\n\nGrowing: has both growth and maintenance respiration\nSnag: has maintenance respiration only, and no leaf \n\nor reproductive organs\n\n\n\n\n\n","category":"type"},{"location":"#XPalm.Leaf","page":"Home","title":"XPalm.Leaf","text":"Leaf(state)\n\nA leaf, which has a state of type LeafState that can be either:\n\nInitiation: in initiation phase (cell division until begining of elongation)\nSpear: spear phase, almost fully developped, but leaflets are not yet deployed\nOpened: deployed and photosynthetically active\nPruned: dead and removed from the plant\nScenescent: dead but still on the plant\n\n\n\n\n\n","category":"type"},{"location":"#XPalm.Male","page":"Home","title":"XPalm.Male","text":"Male(state)\n\nA male inflorescence, which has a state that can be either:\n\nInitiation: in initiation phase (cell division)\nAbortion\nFlowering\nScenescent: dead but still on the plant\nPruned: removed from the plant\n\n\n\n\n\n","category":"type"},{"location":"#XPalm.Palm","page":"Home","title":"XPalm.Palm","text":"Palm(mtg, phytomer_count, max_rank, node_count)\nPalm()\n\nCreate a new Palm. The maximum rank is used to determine how many living phytomers (i.e. leaves) are there on the Palm.\n\nPalm() (without arguments) creates a new Palm with a single phytomer, one leaf, and a Root system.\n\nArguments\n\nmtg: a MTG object\nphytomer_count: total number of phytomers emitted by the Palm since germination, i.e. physiological age\nmtg_node_count: total number of nodes in the MTG (used to determine the unique ID)\n\n\n\n\n\n","category":"type"},{"location":"#XPalm.Phytomer","page":"Home","title":"XPalm.Phytomer","text":"Phytomer(state)\n\nA phytomer\n\n\n\n\n\n","category":"type"},{"location":"#XPalm.add_phytomer!-Tuple{Palm, Dates.Date}","page":"Home","title":"XPalm.add_phytomer!","text":"add_phytomer!(palm, initiation_date)\n\nAdd a new phytomer to the palm\n\nArguments\n\npalm: a Palm\ninitiation_date::Dates.Date: date of initiation of the phytomer \n\n\n\n\n\n","category":"method"},{"location":"#XPalm.add_reproductive_organ-Tuple{XPalm.Phytomer, Any}","page":"Home","title":"XPalm.add_reproductive_organ","text":"ex: add_reproductive_organ(node[:organ], node)\n\n\n\n\n\n","category":"method"},{"location":"#XPalm.determine_sex-Tuple{Any, Any, Any}","page":"Home","title":"XPalm.determine_sex","text":"Determine the sex of the reproductive organ based on the trophic state of the palm tree on x last days\n\n\n\n\n\n","category":"method"}]
}
