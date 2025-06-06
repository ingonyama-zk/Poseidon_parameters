import time

M_s = 128
N =762
t = 3
alpha = 5
n = int(N / t)  # n is log_2(prime)
R_F = 8 
R_P = 56
prime = 21888242871839275222246405745257275088548364400416034343698204186575808495617
F = GF(prime)

timer_start = 0
timer_end = 0

round_constants = ['0x1d066a255517b7fd8bddd3a93f7804ef7f8fcde48bb4c37a59a09a1a97052816', '0x29daefb55f6f2dc6ac3f089cebcc6120b7c6fef31367b68eb7238547d32c1610', '0x1f2cb1624a78ee001ecbd88ad959d7012572d76f08ec5c4f9e8b7ad7b0b4e1d1', '0x0aad2e79f15735f2bd77c0ed3d14aa27b11f092a53bbc6e1db0672ded84f31e5', '0x2252624f8617738cd6f661dd4094375f37028a98f1dece66091ccf1595b43f28', '0x1a24913a928b38485a65a84a291da1ff91c20626524b2b87d49f4f2c9018d735', '0x22fc468f1759b74d7bfc427b5f11ebb10a41515ddff497b14fd6dae1508fc47a', '0x1059ca787f1f89ed9cd026e9c9ca107ae61956ff0b4121d5efd65515617f6e4d', '0x02be9473358461d8f61f3536d877de982123011f0bf6f155a45cbbfae8b981ce', '0x0ec96c8e32962d462778a749c82ed623aba9b669ac5b8736a1ff3a441a5084a4', '0x292f906e073677405442d9553c45fa3f5a47a7cdb8c99f9648fb2e4d814df57e', '0x274982444157b86726c11b9a0f5e39a5cc611160a394ea460c63f0b2ffe5657e', '0x1a1d063e54b1e764b63e1855bff015b8cedd192f47308731499573f23597d4b5', '0x26abc66f3fdf8e68839d10956259063708235dccc1aa3793b91b002c5b257c37', '0x0c7c64a9d887385381a578cfed5aed370754427aabca92a70b3c2b12ff4d7be8', '0x1cf5998769e9fab79e17f0b6d08b2d1eba2ebac30dc386b0edd383831354b495', '0x0f5e3a8566be31b7564ca60461e9e08b19828764a9669bc17aba0b97e66b0109', '0x18df6a9d19ea90d895e60e4db0794a01f359a53a180b7d4b42bf3d7a531c976e', '0x04f7bf2c5c0538ac6e4b782c3c6e601ad0ea1d3a3b9d25ef4e324055fa3123dc', '0x29c76ce22255206e3c40058523748531e770c0584aa2328ce55d54628b89ebe6', '0x198d425a45b78e85c053659ab4347f5d65b1b8e9c6108dbe00e0e945dbc5ff15', '0x25ee27ab6296cd5e6af3cc79c598a1daa7ff7f6878b3c49d49d3a9a90c3fdf74', '0x138ea8e0af41a1e024561001c0b6eb1505845d7d0c55b1b2c0f88687a96d1381', '0x306197fb3fab671ef6e7c2cba2eefd0e42851b5b9811f2ca4013370a01d95687', '0x1a0c7d52dc32a4432b66f0b4894d4f1a21db7565e5b4250486419eaf00e8f620', '0x2b46b418de80915f3ff86a8e5c8bdfccebfbe5f55163cd6caa52997da2c54a9f', '0x12d3e0dc0085873701f8b777b9673af9613a1af5db48e05bfb46e312b5829f64', '0x263390cf74dc3a8870f5002ed21d089ffb2bf768230f648dba338a5cb19b3a1f', '0x0a14f33a5fe668a60ac884b4ca607ad0f8abb5af40f96f1d7d543db52b003dcd', '0x28ead9c586513eab1a5e86509d68b2da27be3a4f01171a1dd847df829bc683b9', '0x1c6ab1c328c3c6430972031f1bdb2ac9888f0ea1abe71cffea16cda6e1a7416c', '0x1fc7e71bc0b819792b2500239f7f8de04f6decd608cb98a932346015c5b42c94', '0x03e107eb3a42b2ece380e0d860298f17c0c1e197c952650ee6dd85b93a0ddaa8', '0x2d354a251f381a4669c0d52bf88b772c46452ca57c08697f454505f6941d78cd', '0x094af88ab05d94baf687ef14bc566d1c522551d61606eda3d14b4606826f794b', '0x19705b783bf3d2dc19bcaeabf02f8ca5e1ab5b6f2e3195a9d52b2d249d1396f7', '0x09bf4acc3a8bce3f1fcc33fee54fc5b28723b16b7d740a3e60cef6852271200e', '0x1803f8200db6013c50f83c0c8fab62843413732f301f7058543a073f3f3b5e4e', '0x0f80afb5046244de30595b160b8d1f38bf6fb02d4454c0add41f7fef2faf3e5c', '0x126ee1f8504f15c3d77f0088c1cfc964abcfcf643f4a6fea7dc3f98219529d78', '0x23c203d10cfcc60f69bfb3d919552ca10ffb4ee63175ddf8ef86f991d7d0a591', '0x2a2ae15d8b143709ec0d09705fa3a6303dec1ee4eec2cf747c5a339f7744fb94', '0x07b60dee586ed6ef47e5c381ab6343ecc3d3b3006cb461bbb6b5d89081970b2b', '0x27316b559be3edfd885d95c494c1ae3d8a98a320baa7d152132cfe583c9311bd', '0x1d5c49ba157c32b8d8937cb2d3f84311ef834cc2a743ed662f5f9af0c0342e76', '0x2f8b124e78163b2f332774e0b850b5ec09c01bf6979938f67c24bd5940968488', '0x1e6843a5457416b6dc5b7aa09a9ce21b1d4cba6554e51d84665f75260113b3d5', '0x11cdf00a35f650c55fca25c9929c8ad9a68daf9ac6a189ab1f5bc79f21641d4b', '0x21632de3d3bbc5e42ef36e588158d6d4608b2815c77355b7e82b5b9b7eb560bc', '0x0de625758452efbd97b27025fbd245e0255ae48ef2a329e449d7b5c51c18498a', '0x2ad253c053e75213e2febfd4d976cc01dd9e1e1c6f0fb6b09b09546ba0838098', '0x1d6b169ed63872dc6ec7681ec39b3be93dd49cdd13c813b7d35702e38d60b077', '0x1660b740a143664bb9127c4941b67fed0be3ea70a24d5568c3a54e706cfef7fe', '0x0065a92d1de81f34114f4ca2deef76e0ceacdddb12cf879096a29f10376ccbfe', '0x1f11f065202535987367f823da7d672c353ebe2ccbc4869bcf30d50a5871040d', '0x26596f5c5dd5a5d1b437ce7b14a2c3dd3bd1d1a39b6759ba110852d17df0693e', '0x16f49bc727e45a2f7bf3056efcf8b6d38539c4163a5f1e706743db15af91860f', '0x1abe1deb45b3e3119954175efb331bf4568feaf7ea8b3dc5e1a4e7438dd39e5f', '0x0e426ccab66984d1d8993a74ca548b779f5db92aaec5f102020d34aea15fba59', '0x0e7c30c2e2e8957f4933bd1942053f1f0071684b902d534fa841924303f6a6c6', '0x0812a017ca92cf0a1622708fc7edff1d6166ded6e3528ead4c76e1f31d3fc69d', '0x21a5ade3df2bc1b5bba949d1db96040068afe5026edd7a9c2e276b47cf010d54', '0x01f3035463816c84ad711bf1a058c6c6bd101945f50e5afe72b1a5233f8749ce', '0x0b115572f038c0e2028c2aafc2d06a5e8bf2f9398dbd0fdf4dcaa82b0f0c1c8b', '0x1c38ec0b99b62fd4f0ef255543f50d2e27fc24db42bc910a3460613b6ef59e2f', '0x1c89c6d9666272e8425c3ff1f4ac737b2f5d314606a297d4b1d0b254d880c53e', '0x03326e643580356bf6d44008ae4c042a21ad4880097a5eb38b71e2311bb88f8f', '0x268076b0054fb73f67cee9ea0e51e3ad50f27a6434b5dceb5bdde2299910a4c9', '0x1acd63c67fbc9ab1626ed93491bda32e5da18ea9d8e4f10178d04aa6f8747ad0', '0x19f8a5d670e8ab66c4e3144be58ef6901bf93375e2323ec3ca8c86cd2a28b5a5', '0x1c0dc443519ad7a86efa40d2df10a011068193ea51f6c92ae1cfbb5f7b9b6893', '0x14b39e7aa4068dbe50fe7190e421dc19fbeab33cb4f6a2c4180e4c3224987d3d', '0x1d449b71bd826ec58f28c63ea6c561b7b820fc519f01f021afb1e35e28b0795e', '0x1ea2c9a89baaddbb60fa97fe60fe9d8e89de141689d1252276524dc0a9e987fc', '0x0478d66d43535a8cb57e9c1c3d6a2bd7591f9a46a0e9c058134d5cefdb3c7ff1', '0x19272db71eece6a6f608f3b2717f9cd2662e26ad86c400b21cde5e4a7b00bebe', '0x14226537335cab33c749c746f09208abb2dd1bd66a87ef75039be846af134166', '0x01fd6af15956294f9dfe38c0d976a088b21c21e4a1c2e823f912f44961f9a9ce', '0x18e5abedd626ec307bca190b8b2cab1aaee2e62ed229ba5a5ad8518d4e5f2a57', '0x0fc1bbceba0590f5abbdffa6d3b35e3297c021a3a409926d0e2d54dc1c84fda6', '0x30347f53e91a637fca1d8a1e828d6fb969e737481ad3376d722513091c0f90c9', '0x0de59a358f0ecd2d5bbb3625c3b071a42b475bca9222507c955254e81e2f98b7', '0x192367e65f923e2f6ade0fad0239743874b77a8de8088d62cc96f373156ecf16', '0x01a992b6af0424b93f830a979873e59685c66affc3a6b6ca87fb421d18dc887d', '0x1e9bdf5427a5620701bb81c2f854ad8ee69ff2b4a8069c8869acd5bd3ef74ec8', '0x1b256e0fb7d5ec339daa27f20a017a07ba8d4adaf1d05142547f82d6082f7a42', '0x2a5bc4ad257499ea42a53a531910f9a32b4db734215d1b8d28256d1b1ef38e70', '0x27fcec3b431befcb471c4df705b59ac018f4bb1c58e49c51008f29a51b837f90', '0x22961d12dc1f96bce1b57afce557ef947e1b8f20e81273eb5533ef8556278a6c', '0x011c5653ac8b64cd159dc124b2dd142fcaeaa2086307c785824d8597f7a1ee1d', '0x1d519feae9827d0b1bb7f14a272f5535a35856fdfbff1bf85a059c31d45681df', '0x2ee9619acd36e9ec3617767f07407f43d48ba40840a736180bfb2ace24f85c7c', '0x2637f99fce7463a906efaadc0c12122e98c670f6363a7e83bf49e225930593db', '0x1c12745737824622fd8f15456b011e1d0b9e4526c415ac38892c7bc6de6c5fa8', '0x19b98d3fc8e2b487c78fbb1eb365c232cf46a209c7c563163947c8be4d4ee971', '0x04bf0ee44e25b5b08c9e5fc181190a5c2548edbbea40951a05e12bf8d3e3fecf', '0x1508862a72542035f7da6febb71116e47efc62d62e31404ed3a789216b7f6718', '0x29684cede059b92e0d17cd476adc475ca6c001641752ccd3c93483c58e651560', '0x11fba1de926dc812f9de635c42f2f4817a5d7203cedf2e1e5b13525d22fae357', '0x1c79b44ba583f341aa2cab67a1e377f0b62dc3229bd5951bae6e048d1407695c', '0x0efac6637312c7025f8981e3bef465f49d4ed20e9a725159f0e265272d406547', '0x0202e9abde9c96289bdae42661a2494d0414b3ca42d99011a4c31ec29a65ed71', '0x182965cfa2bd901525ba84ad7540b380eb65d92099c4f2e6bdab55f7bd7a6e36', '0x2b228d8943f9f31b13de90198396845ed50cd22e08bb9c7078d84810e5b3fcbc', '0x00d577d378751869bdaf4f7a66de23217134dcc67af29ccea82bf5b7f8b53189', '0x243b0fa88aedc975cbe2e286dcdc284cac4ab168a524ecc14b1216cf007135b6', '0x27c7ca4bf4290d1e6b693322655afe507dbed93efbf39852bb64b331e0e8f39f', '0x27d0ab1d52d5dafa31652793025c0b3bc9b1b6d3330a13e05a8432364a9f2b9b', '0x14ae1c11de5120e670cf9be3444611983b71e8cdc6b20a2c667632a10a6237bf', '0x23d1b30e1e91dc0275a0abaab437389623804c387d91e98054ab0fee62b03e8b', '0x2d3071b44b0819a33728c4c945200c5d07b4046697f44a6a9eaa36ec4a768011', '0x1c91211710526c8d43588e11dce44e8d19abe4e74255d170e9c17584f0578bdb', '0x124d84d94425e4dcc9494762bd423bf08c970c63e9de1a173fe7e877658e3154', '0x0a0487e7fe653ff630f59af8443b4f79632e918208bc645fe96e0364711669b8', '0x10a8c9fa3ae6b3f010202d63a195e5a1ce6df40b60a158faca9488330a037bb8', '0x168dc103f522a4558d97b24a71990ed38203879551ccc4bf3dc57d6043d7821c', '0x22417ea97fa7ab926f6b4d36d00a86b03e0f7be7d6d8e2a1955e954c18b33a8b', '0x2a6174d4b9fa90538e4539a1bc5d2c88aabfae97ef1e66644d4c4588ddd62c84', '0x1cc248057eb0fd28f1f753f5f85fe03ba0ec8f3053b06f4feb4a3dbd496def2f', '0x14dbcc08b921c358db26d85746562d0b51917d56eb9e6779664e502bea28462e', '0x1d28a4f9cd6146551ebdf33afcb5babfebd3eb9da7857fb0addb965bf3e3a372', '0x1596900ce091cea8799615f5f52961461df7f00fca9d73b55574a8085d74b5b3', '0x0978d75a71e9ccccc2ff0dbca6a34784e5ca3101c2ea84e1ea7684bbb6e18837', '0x1b1f1cb131cb037d14d158726ce96b73e7fa17c075872e056644e73d8d925dd7', '0x156eecc345d11b0073e482762012502ee508af74557fb1daac95b01934938e62', '0x224421a4d0a2fe503cd90416eb80593e6def8d1f1640804b15df556815548d02', '0x0a17879cf1b30bea8c75376232dfa6666a9a106533a677204fe5832cb47e437d', '0x25da75173ebcbd286269ed32efbc55ee6db9bb4ebe637705f605c498e663c817', '0x0aa00a02a18574063e1186ef3dedb586bbbdc335dcbd30fd8e983b1642929927', '0x300e19c48ed4866175f50acdaa379c042c441c1cb34c4001d1fe9358f8b94aad', '0x2f22e43e2ec235da7c99e04f7d34d725808e3653d322ac303a5ea1b0c4f6d630', '0x03adcd0ed6032a56b61f76a0122c0b67e7c7665ec79da9ee005a50ccf490ea4c', '0x235297c114d27b55cbdf5121cf44d611b3e9be47a9c9768f5ab8807fcd2435a7', '0x10f1182b447cff3375f3375eff839c2689168f09c65ed44114be7287a2f8b4c8', '0x1e6adbf9397247807b6441703ce1a57e61c2ab95de1e7ffba10c4fcf49a57966', '0x01a0c48c7936505b63833020c75eb00ea88939a33c810f761a4b045380135456', '0x2dbc47b5021936f8c3577fbaa65b4fda57bcebd012ae5e7aa4e77703be6d030e', '0x1327666b84984cf65756d28092195e931185a3c928b09d46eb332b35ee5a468c', '0x2bc934e3f91921ec3c28edc8c725f79d7e169397ed56d8be18ac39d308636ca9', '0x183dd78940fbb6ecd564b267c43b5e5eb87802d66f897aeaf8f03221824a5cc0', '0x2c3b99c113caa8215cf5a9377346efac167c54563dd350fac23688aca7fa205b', '0x0cfc218f63c5a59e9778251924fcbb0df010313bec2406b7e8ef87a9d82830cd', '0x301a1be9217e2cbfa3c9fbb8e1cdba31759539b27c2f4d932b6e075992bc073d', '0x0451168db6416d9a2bd56d3b05303d395ecb8636f42c4e2cbcfc996f0a8b8d4f', '0x0279fe381976eda48032c8ae75f1aca0662bee641c5df4a96e52da33bd117458', '0x2dd3f1dea0c8d9f4793948270d814241747ef420a5f0d75829527d36c740e678', '0x1bde2068fd10ccc3eaec0104a0008897fdf255ac8d6694d18d81dbb26682f28b', '0x18e9925c649a6bf7c819de04a1a15e1bdff84104178e67c3be59a3213b047613', '0x0281fc392973d4972722a9b137a625c903716d7aad74c22795d055cb4323bd14', '0x0757134be627b5ff9b3d7a20e7845f384fe26ae2e9c7d161df4e63e8db363415', '0x1e96e7da78032be3b45df5375e5aff61db332e1e5c0f67d778d8dee4db8cb576', '0x10e29927e946e8145c6f4c615904cbde50fd257d13c87c4bbd0b65b976de377c', '0x104f75276d0da2364a0e03d4f115e83167bc3bc3340b86eae7e98192104d6c60', '0x01c6368cb969e2f8d255e95d5e962ba969624075cb6dfa5a04b0bd5ed1cd62dc', '0x106fffc94ca4acbd764af0e7f76856e1b30a6e067befab8837a5a15cd32be88f', '0x15e78bf1f7c8bfe17dbd8a0155728c644fcbc3515aed35dd569b52010f0c95a2', '0x000cab14c0ff2cf1718fe666467055d18d8c192e3c02d598a38f5515985d16b8', '0x23f34102470d94829f328e6141909b903f45d4deea6ce7ff017803bb1abf9c75', '0x1fd2d8ce7613d6b61d65f6ef7284f392e2cf207b0d323ba0ee0fc2aaa6935da6', '0x0c63086a8a20a108fa13fc8a57d078f0df03695bad70b3ac02cbdd24374fad45', '0x27cd3730e4714199fdb215a5c8d967f46b185fcc2f0e548eaab631aae5a2b54c', '0x15adaa75fc1f1595186c0d4d4a0164604cd1a1cf69f15fca5ec79c1e524be22b', '0x05aa5e4fb84931226fe71314cdc4d64bd1e15619a346a9e8853183fb7ae19d02', '0x27fb8cd694fcd1d058313959fcfc621a3ccb7a9a8ea245ac31c13fb6a57c4022', '0x2be0953fd8b1d2f6e463ee9a3f70e3e817565d61af26c621713b207ad34ec7a7', '0x217143e8ae458a9ef116ca2a15fc36cc469fcbe87b9c1ab6fce03b25d20c25a2', '0x29c3b69f65b5cfd2cffd3123a0118d90f945e1eba04fbcd916fa11b3d59328f2', '0x2951ccd20b0a35b9603de573d11918a98e99662b3311144ef81c16c84ed32fe9', '0x202d7cf41dcbbb10b69b64f3e7d609617b9ee088de1db8b7ac4bcfba87dbd048', '0x014d390c7229d74a5b39dddc6f0395eec036a1e0d377cfcc9b1ad0686c3743b5', '0x1479c1cfbd48817240820dc11e59d9bf16f7dfa3ebfcc3d4dd7e97292296262e', '0x0684d98bb96761750f65d8933ab43397d4a96d8b6c61ded5816fcd74b562dfa0', '0x1f4f4cd32539eddcda05a729297a2a5f892cd50179df7ce1e4008373c89447a8', '0x03326d7fdcd6ccc2371731b5752d957d1dfd792a5351c10bd958ffb04635b84f', '0x1d5b99cb1e95e9d975bd7f99d1a95d7f0a5688d7e4965aafbd76a271cb6e876d', '0x13d909a621a86fcb4e9978dae7f77a014174cc9f6ff6b8ba496f0513d2af1054', '0x16e7671d2d3a50c7cdbf3270e8bf1c4f18221f7bd7f899e313c45e28174d17ce', '0x03aac5e52aedb6acad82466f062d38d8294c6af6b5900c700c5323684153fdcd', '0x086f0806c45cf713dc2c19a3332faba6df3a4c8c93e292c996d0886c81916d34', '0x2a845e4cb08384e51a40a14687da5aa91f9807d575b0d88a34e1f85a2e20e969', '0x18d2a59257afc8bd005f3b2804cbeea1cab18b6a62efe2f4742d1e0eccf06e8b', '0x1a2d3094ec6931ac4d53e69338e5fb98610dea28731816029b8ad15be5361be9', '0x1cfe7a330a5001825299978e53f555dcd300210260c1d589aeca0df6089cad6d', '0x0da40fff9f10c73aea59002d40230b8933f2fdbc192553057e2784530825b921', '0x0e05b77a1a396b75dbf6e8e234f30c846561de1faec70eefc0393df01e079ff5', '0x1a044b846a4bb239dcd58b95d6656a452151bec40f3084b4325f918029bf262e', '0x2e139ae51418b64f78043335ddcab1b8c349540db935e2bca89493b0ea189784', '0x0741808912ca9cbf94a0228663125866e4f28f77af515b1170ee063a7f676240', '0x0b29628ee57e1d55f70f9059bb80e3608642e046003218807f69b40d94e8cc91', '0x060804c31fb3be30dd5475cdcabce8afa21ddf46b4631583565f949933fbf9d1', '0x2760f6b6590a73a863f9bd30d8cb6002d195fa252b0cd84f36d3955e853b3592', '0x14aa7543a56c144a6fa53cb6d2e0537c2c65b571104def5a67d6f228492c2c5b']

MDS_matrix=[['0x09600146bec7f4fd625ea9db1f247c6376f479f8fa4b34f1227f14ac41bc4cd3', '0x1eb832b908b873be41b430e81e9f5fa648080f6a139f5a64570e848cb09c9292', '0x00868c3677aaeb8a5b01fc0c44f5d2367a26db160ae28eb98b63cccbea20d8af'],['0x0b9a382db8289f520ece763cbb2094c444663a2bf55db56999a4614a96504ebe', '0x2de7772476f303a6d2879cdcc47c1113ef4e1936fb876d034bbcda5acdc435ec', '0x27948d4bcb6d665205572ebbde236b7624da6487f1b18fdbbc44e7a2dd3d793d'],['0x1fcefc218b5675feed028865d2f9ef22a1e31f41f7ce7631f645471265344dc4', '0x0d7b02b0f922e679dfd828024c17296596770fdc936f9b16ae612716ce444b3b', '0x1ee23b55636874a2ca16a9f3c1f9bc4ff17410f229a1271d46fdc664ee4511c7']]

MDS_matrix_field = matrix(F, t, t)

for i in range(0, t):
    for j in range(0, t):
        MDS_matrix_field[i, j] = F(int(MDS_matrix[i][j], 16))
round_constants_field = []
for i in range(0, (R_F + R_P) * t):
    round_constants_field.append(F(int(round_constants[i], 16)))


#MDS_matrix_field = MDS_matrix_field.transpose() # QUICK FIX TO CHANGE MATRIX MUL ORDER (BOTH M AND M^T ARE SECURE HERE!)

def print_words_to_hex(words):
    hex_length = int(ceil(float(n) / 4)) + 2 # +2 for "0x"
    print(["{0:#0{1}x}".format(int(entry), hex_length) for entry in words])

def print_concat_words_to_large(words):
    hex_length = int(ceil(float(n) / 4))
    nums = ["{0:0{1}x}".format(int(entry), hex_length) for entry in words]
    final_string = "0x" + ''.join(nums)
    print(final_string)

def calc_equivalent_constants(constants):
    constants_temp = [constants[index:index+t] for index in range(0, len(constants), t)]

    MDS_matrix_field_transpose = MDS_matrix_field.transpose()

    # Start moving round constants up
    # Calculate c_i' = M^(-1) * c_(i+1)
    # Split c_i': Add c_i'[0] AFTER the S-box, add the rest to c_i
    # I.e.: Store c_i'[0] for each of the partial rounds, and make c_i = c_i + c_i' (where now c_i'[0] = 0)
    num_rounds = R_F + R_P
    R_f = R_F / 2
    for i in range(num_rounds - 2 - R_f, R_f - 1, -1):
        inv_cip1 = list(vector(constants_temp[i+1]) * MDS_matrix_field_transpose.inverse())
        constants_temp[i] = list(vector(constants_temp[i]) + vector([0] + inv_cip1[1:]))
        constants_temp[i+1] = [inv_cip1[0]] + [0] * (t-1)


    return constants_temp

def calc_equivalent_matrices():
    # Following idea: Split M into M' * M'', where M'' is "cheap" and M' can move before the partial nonlinear layer
    # The "previous" matrix layer is then M * M'. Due to the construction of M', the M[0,0] and v values will be the same for the new M' (and I also, obviously)
    # Thus: Compute the matrices, store the w_hat and v_hat values

    MDS_matrix_field_transpose = MDS_matrix_field.transpose()

    w_hat_collection = []
    v_collection = []
    v = MDS_matrix_field_transpose[[0], list(range(1,t))]
    # print "M:", MDS_matrix_field_transpose
    # print "v:", v
    M_mul = MDS_matrix_field_transpose
    M_i = matrix(F, t, t)
    for i in range(R_P - 1, -1, -1):
        M_hat = M_mul[list(range(1,t)), list(range(1,t))]
        w = M_mul[list(range(1,t)), [0]]
        v = M_mul[[0], list(range(1,t))]
        v_collection.append(v.list())
        w_hat = M_hat.inverse() * w
        w_hat_collection.append(w_hat.list())

        # Generate new M_i, and multiplication M * M_i for "previous" round
        M_i = matrix.identity(t)
        M_i[list(range(1,t)), list(range(1,t))] = M_hat
        #M_mul = MDS_matrix_field_transpose * M_i

        test_mat = matrix(F, t, t)
        test_mat[[0], list(range(0, t))] = MDS_matrix_field_transpose[[0], list(range(0, t))]
        test_mat[[0], list(range(1, t))] = v
        test_mat[list(range(1, t)), [0]] = w_hat
        test_mat[list(range(1,t)), list(range(1,t))] = matrix.identity(t-1)

        # print M_mul == M_i * test_mat
        M_mul = MDS_matrix_field_transpose * M_i
        #return[M_i, test_mat]


        #M_mul = MDS_matrix_field_transpose * M_i
        #exit()
    #exit()
        

    # print [M_i, w_hat_collection, MDS_matrix_field_transpose[0, 0], v.list()]
    return [M_i, v_collection, w_hat_collection, MDS_matrix_field_transpose[0, 0]]

def cheap_matrix_mul(state_words, v, w_hat, M_0_0):
    state_words_new = [0] * t
    # row_1 = [M_0_0] + v
    # print "r1:", row_1
    # state_words_new[0] = sum([row_1[i] * state_words[i] for i in range(0, t)])
    # mul_column = [(state_words[0] * w_hat[i]) for i in range(0, t-1)]
    # add_column = [(mul_column[i] + state_words[i+1]) for i in range(0, t-1)]
    # state_words_new = [state_words_new[0]] + add_column
    # print "1:", state_words_new
    column_1 = [M_0_0] + w_hat
    state_words_new[0] = sum([column_1[i] * state_words[i] for i in range(0, t)])
    mul_row = [(state_words[0] * v[i]) for i in range(0, t-1)]
    add_row = [(mul_row[i] + state_words[i+1]) for i in range(0, t-1)]
    state_words_new = [state_words_new[0]] + add_row

    # test_mat = matrix(F, t, t)
    # # print "r2:", matrix([M_0_0] + v).list()
    # # print row_1 == matrix([M_0_0] + v).list()
    # test_mat[[0], range(0, t)] = matrix([M_0_0] + v)
    # test_mat[range(1, t), [0]] = matrix(w_hat).transpose()
    # test_mat[range(1,t), range(1,t)] = matrix.identity(t-1)
    # state_words_new = list(vector(state_words) * test_mat)
    # print "2:", state_words_new

    return state_words_new

def perm(input_words):
    round_constants_field_new = calc_equivalent_constants(round_constants_field)
    [M_i, v_collection, w_hat_collection, M_0_0] = calc_equivalent_matrices()
    #[M_i, test_mat] = calc_equivalent_matrices()
    
    global timer_start, timer_end

    timer_start = time.time()

    R_f = int(R_F / 2)

    round_constants_round_counter = 0

    state_words = list(input_words)

    # First full rounds
    for r in range(0, R_f):
        # Round constants, nonlinear layer, matrix multiplication
        for i in range(0, t):
            state_words[i] = state_words[i] + round_constants_field_new[round_constants_round_counter][i]
        for i in range(0, t):
            state_words[i] = (state_words[i])^alpha
        state_words = list(MDS_matrix_field * vector(state_words))
        round_constants_round_counter += 1

    # Middle partial rounds
    # Initial constants addition
    for i in range(0, t):
        state_words[i] = state_words[i] + round_constants_field_new[round_constants_round_counter][i]
    # First full matrix multiplication
    state_words = list(vector(state_words) * M_i)
    for r in range(0, R_P):
        # Round constants, nonlinear layer, matrix multiplication
        #state_words = list(vector(state_words) * M_i)
        state_words[0] = (state_words[0])^alpha
        # Moved constants addition
        if r < (R_P - 1):
            round_constants_round_counter += 1
            state_words[0] = state_words[0] + round_constants_field_new[round_constants_round_counter][0]
        # Optimized multiplication with cheap matrices
        state_words = cheap_matrix_mul(state_words, v_collection[R_P - r - 1], w_hat_collection[R_P - r - 1], M_0_0)
    round_constants_round_counter += 1

    # Last full rounds
    for r in range(0, R_f):
        # Round constants, nonlinear layer, matrix multiplication
        for i in range(0, t):
            state_words[i] = state_words[i] + round_constants_field_new[round_constants_round_counter][i]
        for i in range(0, t):
            state_words[i] = (state_words[i])^alpha
        state_words = list(MDS_matrix_field * vector(state_words))
        round_constants_round_counter += 1

    timer_end = time.time()
    
    return state_words

def perm_original(input_words):
    round_constants_field_new = [round_constants_field[index:index+t] for index in range(0, len(round_constants_field), t)]

    global timer_start, timer_end
    
    timer_start = time.time()

    R_f = int(R_F / 2)

    round_constants_round_counter = 0

    state_words = list(input_words)

    # First full rounds
    for r in range(0, R_f):
        # Round constants, nonlinear layer, matrix multiplication
        for i in range(0, t):
            state_words[i] = state_words[i] + round_constants_field_new[round_constants_round_counter][i]
        for i in range(0, t):
            state_words[i] = (state_words[i])^alpha
        state_words = list(MDS_matrix_field * vector(state_words))
        round_constants_round_counter += 1

    # Middle partial rounds
    for r in range(0, R_P):
        # Round constants, nonlinear layer, matrix multiplication
        for i in range(0, t):
            state_words[i] = state_words[i] + round_constants_field_new[round_constants_round_counter][i]
        state_words[0] = (state_words[0])^alpha
        state_words = list(MDS_matrix_field * vector(state_words))
        round_constants_round_counter += 1

    # Last full rounds
    for r in range(0, R_f):
        # Round constants, nonlinear layer, matrix multiplication
        for i in range(0, t):
            state_words[i] = state_words[i] + round_constants_field_new[round_constants_round_counter][i]
        for i in range(0, t):
            state_words[i] = (state_words[i])^alpha
        state_words = list(MDS_matrix_field * vector(state_words))
        round_constants_round_counter += 1
    
    timer_end = time.time()

    return state_words

input_words = []
for i in range(0, t):
    input_words.append(F(i))

output_words = None
num_iterations = 10
total_time_passed = 0
for i in range(0, num_iterations):
    output_words = perm_original(input_words)
    time_passed = timer_end - timer_start
    total_time_passed += time_passed
average_time = total_time_passed / float(num_iterations)
print("Average time for unoptimized:", average_time)

print("Input:")
print_words_to_hex(input_words)
print("Output:")
print_words_to_hex(output_words)

# print("Input (concat):")
# print_concat_words_to_large(input_words)
# print("Output (concat):")
# print_concat_words_to_large(output_words)

total_time_passed = 0
for i in range(0, num_iterations):
    output_words = perm(input_words)
    time_passed = timer_end - timer_start
    total_time_passed += time_passed
average_time = total_time_passed / float(num_iterations)
print("Average time for optimized:", average_time)

print("Input:")
print_words_to_hex(input_words)
print("Output:")
print_words_to_hex(output_words)

# print("Input (concat):")
# print_concat_words_to_large(input_words)
# print("Output (concat):")
# print_concat_words_to_large(output_words)



#----snippet to print optimized constants used in this code

round_constants_field_new = calc_equivalent_constants(round_constants_field)
[M_i, v_collection, w_hat_collection, M_0_0] = calc_equivalent_matrices()

# Flags
write_file = True

FILE = None
if write_file == True:
    FILE = open("optimized_poseidon_params_n%d_t%d_alpha%d_M%d.txt"%(n, t, alpha, M_s),'w')
    FILE.write("Params: n=%d, t=%d, alpha=%d, M=%d, R_F=%d, R_P=%d\n"%(n, t, alpha, M_s, R_F,R_P))
    FILE.write("Modulus = %d\n"%(prime))
#    FILE.write("Number of S-boxes: %d\n"%(ROUND_NUMBERS[2]))
    # FILE.write("Number of S-boxes per state element: %d\n"%(ceil(ROUND_NUMBERS[2] / float(NUM_CELLS))))

def print_round_constants_optimized(round_constants_optimized,n):
    if write_file == True:
            FILE.write("Optimized Round constants for GF(p):\n")

#   hex_length = int(ceil(float(n) / 4)) + 2 # +2 for "0x"
#    print(["{0:#0{1}x}".format(hex(entry), hex_length) for entry in round_constants_optimized])

    if write_file == True:
        FILE.write(str([entry for entry in round_constants_optimized]) + "\n\n")

def print_pre_sparse(M, t):       
    matrix_string = "["
    for i in range(0, t):
        matrix_string += str([entry for entry in M[i]])
        if i < (t-1):
            matrix_string += ","
    matrix_string += "]"
   # print("Pre_sparse MDS matrix:\n", matrix_string)
    if write_file == True:
        FILE.write("Pre_sparse MDS matrix::\n" + str(matrix_string)+ "\n\n")

def print_v(v_collection):
    if write_file == True:
        FILE.write("v collection: vector dimension: 1 x "+str(t-1)+"\n ")
        FILE.write(str([entry for entry in v_collection]) + "\n \n ")

def print_w_hat(w_hat_collection):
    if write_file == True:
        FILE.write("w_hat_collection:  vector dimension:" +str(t-1)+ " x 1" + "\n")
        FILE.write(str([entry for entry in w_hat_collection]) + "\n\n")

print_round_constants_optimized(round_constants_field_new, n)
print_pre_sparse(M_i, t)

if write_file == True:
    FILE.write("M_0_0:\n " + str(M_0_0)+ "\n\n")

print_v(v_collection)
print_w_hat(w_hat_collection)


if write_file == True:
    FILE.close()