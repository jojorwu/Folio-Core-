package io.papermc.paper.threadedregions;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class ThreadedRegionizerTest {

    @Test
    void testAddAndRemoveSingleChunk() {
        ThreadedRegionizer<DummyRegion, DummySection> regionizer = new ThreadedRegionizer<>(
            2, 0.5, 1, 1, 4, null, new DummyCallbacks()
        );

        regionizer.addChunk(0, 0);
        assertNotNull(regionizer.getRegionAtSynchronised(0, 0));
        regionizer.removeChunk(0, 0);
        assertNull(regionizer.getRegionAtSynchronised(0, 0));
    }

    @Test
    void testMerge() {
        ThreadedRegionizer<DummyRegion, DummySection> regionizer = new ThreadedRegionizer<>(
            2, 0.5, 1, 1, 4, null, new DummyCallbacks()
        );

        regionizer.addChunk(0, 0);
        regionizer.addChunk(1, 1);
        assertSame(regionizer.getRegionAtSynchronised(0, 0), regionizer.getRegionAtSynchronised(1, 1));
    }

    @Test
    void testSplit() {
        ThreadedRegionizer<DummyRegion, DummySection> regionizer = new ThreadedRegionizer<>(
            2, 0.5, 1, 1, 4, null, new DummyCallbacks()
        );

        regionizer.addChunk(0, 0);
        regionizer.addChunk(1, 0);
        regionizer.addChunk(2, 0);
        regionizer.addChunk(3, 0);
        regionizer.addChunk(4, 0);

        assertSame(regionizer.getRegionAtSynchronised(0, 0), regionizer.getRegionAtSynchronised(4, 0));

        regionizer.removeChunk(2, 0);

        assertNotSame(regionizer.getRegionAtSynchronised(0, 0), regionizer.getRegionAtSynchronised(4, 0));
    }

    @Test
    void testTicking() {
        ThreadedRegionizer<DummyRegion, DummySection> regionizer = new ThreadedRegionizer<>(
            2, 0.5, 1, 1, 4, null, new DummyCallbacks()
        );

        regionizer.addChunk(0, 0);
        regionizer.addChunk(10, 10);

        ThreadedRegionizer.ThreadedRegion<DummyRegion, DummySection> region1 = regionizer.getRegionAtSynchronised(0, 0);
        ThreadedRegionizer.ThreadedRegion<DummyRegion, DummySection> region2 = regionizer.getRegionAtSynchronised(10, 10);

        assertNotSame(region1, region2);

        assertTrue(region1.tryMarkTicking(() -> false));

        regionizer.addChunk(1, 0);

        assertNotSame(region1, regionizer.getRegionAtSynchronised(1, 0));
    }
}

class DummyRegion implements ThreadedRegionizer.ThreadedRegionData<DummyRegion, DummySection> {
    @Override
    public void split(ThreadedRegionizer<DummyRegion, DummySection> regioniser, it.unimi.dsi.fastutil.longs.Long2ReferenceOpenHashMap<ThreadedRegionizer.ThreadedRegion<DummyRegion, DummySection>> into, it.unimi.dsi.fastutil.objects.ReferenceOpenHashSet<ThreadedRegionizer.ThreadedRegion<DummyRegion, DummySection>> regions) {
    }

    @Override
    public void mergeInto(ThreadedRegionizer.ThreadedRegion<DummyRegion, DummySection> into) {
    }
}

class DummySection implements ThreadedRegionizer.ThreadedRegionSectionData {
}

class DummyCallbacks implements ThreadedRegionizer.RegionCallbacks<DummyRegion, DummySection> {
    @Override
    public DummySection createNewSectionData(int sectionX, int sectionZ, int sectionShift) {
        return new DummySection();
    }

    @Override
    public DummyRegion createNewData(ThreadedRegionizer.ThreadedRegion<DummyRegion, DummySection> forRegion) {
        return new DummyRegion();
    }

    @Override
    public void onRegionCreate(ThreadedRegionizer.ThreadedRegion<DummyRegion, DummySection> region) {
    }

    @Override
    public void onRegionDestroy(ThreadedRegionizer.ThreadedRegion<DummyRegion, DummySection> region) {
    }

    @Override
    public void onRegionActive(ThreadedRegionizer.ThreadedRegion<DummyRegion, DummySection> region) {
    }

    @Override
    public void onRegionInactive(ThreadedRegionizer.ThreadedRegion<DummyRegion, DummySection> region) {
    }

    @Override
    public void preMerge(ThreadedRegionizer.ThreadedRegion<DummyRegion, DummySection> from, ThreadedRegionizer.ThreadedRegion<DummyRegion, DummySection> into) {
    }

    @Override
    public void preSplit(ThreadedRegionizer.ThreadedRegion<DummyRegion, DummySection> from, java.util.List<ThreadedRegionizer.ThreadedRegion<DummyRegion, DummySection>> into) {
    }
}