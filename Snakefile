rule run_all_of_me:
    input: "output/plots/all.cmp.matrix.png"
    

rule download_genomes:
    output:   # genomes are now being downloaded to a dir called "genomes"
        one="output/rawdata/1.fa.gz", 
        two="output/rawdata/2.fa.gz", 
        three="output/rawdata/3.fa.gz", 
        four="output/rawdata/4.fa.gz", 
        five="output/rawdata/5.fa.gz"
    shell: """
       wget https://osf.io/t5bu6/download -O {output.one}  # refer to each genome using wildcard
       wget https://osf.io/ztqx3/download -O {output.two}
       wget https://osf.io/w4ber/download -O {output.three}
       wget https://osf.io/dnyzp/download -O {output.four}
       wget https://osf.io/ajvqk/download -O {output.five}
    """

rule sketch_genomes:
    input:
        "output/rawdata/{name}.fa.gz"
    output:
        "output/sketch/{name}.fa.gz.sig"
    shell: """
        sourmash compute -k 31 {input} -o {output}
    """

rule compare_genomes:
    input:
        expand("output/sketch/{n}.fa.gz.sig", n=[1, 2, 3, 4, 5])
    output:
        cmp = "output/cmp/all.cmp",
        labels = "output/cmp/all.cmp.labels.txt"
    shell: """
        sourmash compare {input} -o {output.cmp}
    """

rule plot_genomes:
    input:
        cmp = "output/cmp/all.cmp",
        labels = "output/cmp/all.cmp.labels.txt"
    output:
        "output/plots/all.cmp.matrix.png",
        "output/plots/all.cmp.hist.png",
        "output/plots/all.cmp.dendro.png",
    shell: """
        sourmash plot {input.cmp} --output-dir output/plots/
    """
