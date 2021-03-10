rule run_all_of_me:
    input: "output/all.cmp.matrix.png"
    

rule download_genomes:
    output: "output/1.fa.gz", "output/2.fa.gz", "output/3.fa.gz", "output/4.fa.gz", "output/5.fa.gz"
    shell: """
       wget https://osf.io/t5bu6/download -O output/1.fa.gz
       wget https://osf.io/ztqx3/download -O output/2.fa.gz
       wget https://osf.io/w4ber/download -O output/3.fa.gz
       wget https://osf.io/dnyzp/download -O output/4.fa.gz
       wget https://osf.io/ajvqk/download -O output/5.fa.gz
    """

rule sketch_genomes:
    input:
        "output/{name}.fa.gz"
    output:
        "output/{name}.fa.gz.sig"
    shell: """
        sourmash compute -k 31 {input} -o {output}
    """

rule compare_genomes:
    input:
        expand("output/{n}.fa.gz.sig", n=[1, 2, 3, 4, 5])
    output:
        cmp = "output/all.cmp",
        labels = "output/all.cmp.labels.txt"
    shell: """
        sourmash compare {input} -o {output.cmp}
    """

rule plot_genomes:
    input:
        cmp = "output/all.cmp",
        labels = "output/all.cmp.labels.txt"
    output:
        "output/all.cmp.matrix.png",
        "output/all.cmp.hist.png",
        "output/all.cmp.dendro.png",
    shell: """
        sourmash plot {input.cmp} --output-dir output/
    """
